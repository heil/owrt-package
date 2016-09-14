vcl 4.0;

import std;
import directors;

backend server1 { # Define one backend
  .host = "127.0.0.1";    # IP or Hostname of backend
  .port = "8081";           # Port Apache or whatever is listening
  .max_connections = 300; # That's it

  .probe = {
    #.url = "/"; # short easy way (GET /)
    # We prefer to only do a HEAD /
    .request =
      "HEAD / HTTP/1.1"
      "Host: localhost"
      "Connection: close";

    .interval  = 5s; # check the health of each backend every 5 seconds
    .timeout   = 1s; # timing out after 1 second.
    .window    = 5;  # If 3 out of the last 5 polls succeeded the backend is considered healthy, otherwise it will be marked as sick
    .threshold = 3;
  }

  .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
  .connect_timeout        = 5s;     # How long to wait for a backend connection?
  .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
}

backend server2 { # Define one backend
  .host = "127.0.0.1";    # IP or Hostname of backend
  .port = "83";           # Port Apache or whatever is listening
  .max_connections = 300; # That's it

  .probe = {
    #.url = "/"; # short easy way (GET /)
    # We prefer to only do a HEAD /
    .request =
      "HEAD / HTTP/1.1"
      "Host: localhost"
      "Connection: close";

    .interval  = 5s; # check the health of each backend every 5 seconds
    .timeout   = 1s; # timing out after 1 second.
    .window    = 5;  # If 3 out of the last 5 polls succeeded the backend is considered healthy, otherwise it will be marked as sick
    .threshold = 3;
  }

  .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
  .connect_timeout        = 5s;     # How long to wait for a backend connection?
  .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
}

acl purge {
    "localhost";
    "172.24.54.0"/24;
}

sub vcl_init {
  # Called when VCL is loaded, before any requests pass through it.
  # Typically used to initialize VMODs.

  new vdir = directors.round_robin();

  vdir.add_backend(server1);
  vdir.add_backend(server2);
}


sub vcl_recv {
  # Happens before we check if we have this in cache already.
  #
  # Typically you clean up the request here, removing cookies you don't need,
  # rewriting the request, etc.

  # Health Checking
  if (req.url == "/varnishcheck" ) {
		return(synth(751,"health check OK!"));
	}

  set req.backend_hint = vdir.backend();

  if ( req.http.host ~ "(www\.)?abcd\.")
  {
    set req.backend_hint = vdir.backend();
  } else 	{
    set req.backend_hint = vdir.backend();
  }

  # Normalize the header, remove the port (in case you're testing this on various TCP ports)
  set req.http.Host = regsub(req.http.Host, ":[0-9]+", "");

  # Normalize the query arguments
  set req.url = std.querysort(req.url);

  # Allow purging
  if (req.method == "PURGE") {
    if (!client.ip ~ purge) { # purge is the ACL defined at the begining
        # Not from an allowed IP? Then die with an error.
        return (synth(405, "This IP is not allowed to send PURGE requests."));
    }
    # If you got this stage (and didn't error out above), purge the cached result
    return (purge);
  }

  # Only deal with "normal" types
  if (req.method != "GET" &&
          req.method != "HEAD" &&
          req.method != "PUT" &&
          req.method != "POST" &&
          req.method != "TRACE" &&
          req.method != "OPTIONS" &&
          req.method != "PATCH" &&
          req.method != "DELETE") {
      /* Non-RFC2616 or CONNECT which is weird. */
      return (pipe);
  }

  # Implementing websocket support (https://www.varnish-cache.org/docs/4.0/users-guide/vcl-example-websockets.html)
  if (req.http.Upgrade ~ "(?i)websocket") {
    return (pipe);
  }

  # Only cache GET or HEAD requests. This makes sure the POST requests are always passed.
  if (req.method != "GET" && req.method != "HEAD") {
    return (pass);
  }

  if (	req.url ~ "^/roller-ui" || req.url ~ "^/karlheinz/*" ) {
    return (pass);
  }

  if (req.url ~ "^[^?]*\.(mp[34]|rar|tar|tgz|gz|wav|zip|bz2|xz|7z|avi|mov|ogm|mpe?g|mk[av]|webm)(\?.*)?$") {
    unset req.http.Cookie;
    return (hash);
  }

  if (req.url ~ "^[^?]*\.(bmp|bz2|css|doc|eot|flv|gif|gz|ico|jpeg|jpg|js|less|pdf|png|rtf|swf|txt|woff|xml)(\?.*)?$") {
    unset req.http.Cookie;
    return (hash);
  }

  # Not cacheable by default
  if (req.http.Authorization) {
      return (pass);
  }

  return (hash);
}

sub vcl_pipe {

  #Connection Close here

  set bereq.http.Connection = "Close";

  # Implementing websocket support (https://www.varnish-cache.org/docs/4.0/users-guide/vcl-example-websockets.html)
  if (req.http.upgrade) {
      set bereq.http.upgrade = req.http.upgrade;
  }
  return (pipe);
}

sub vcl_pass {
  # Called upon entering pass mode. In this mode, the request is passed on to the backend, and the
  # backend's response is passed on to the client, but is not entered into the cache. Subsequent
  # requests submitted over the same client connection are handled normally.

  # return (pass);
}

sub vcl_hash {
  # Called after vcl_recv to create a hash value for the request. This is used as a key
  # to look up the object in Varnish.

  hash_data(req.url);

  if (req.http.host) {
    hash_data(req.http.host);
  } else {
    hash_data(server.ip);
  }

  # hash cookies for requests that have them
  if (req.http.Cookie) {
    hash_data(req.http.Cookie);
  }
}


sub vcl_hit {
  # Called when a cache lookup is successful.

  if (obj.ttl >= 0s) {
    # A pure unadultered hit, deliver it
    return (deliver);
  }

# We have no fresh fish. Lets look at the stale ones.
  if (std.healthy(req.backend_hint)) {
    # Backend is healthy. Limit age to 10s.
    if (obj.ttl + 10s > 0s) {
      #set req.http.grace = "normal(limited)";
      return (deliver);
    } else {
      # No candidate for grace. Fetch a fresh object.
      return(fetch);
    }
  } else {
    # backend is sick - use full grace
      if (obj.ttl + obj.grace > 0s) {
      #set req.http.grace = "full";
      return (deliver);
    } else {
      # no graced object.
      return (fetch);
    }
  }

  # fetch & deliver once we get the result
  return (fetch); # Dead code, keep as a safeguard
}

sub vcl_miss {
  # Called after a cache lookup if the requested document was not found in the cache. Its purpose
  # is to decide whether or not to attempt to retrieve the document from the backend, and which
  # backend to use.

  return (fetch);
}

sub vcl_backend_response {
  # Happens after we have read the response headers from the backend.
  #
  # Here you clean the response headers, removing silly Set-Cookie headers
  # and other mistakes your backend does.


  #cache static files
  if (bereq.url ~ "^[^?]*\.(bmp|bz2|css|doc|eot|flv|gif|gz|ico|jpeg|jpg|js|less|mp[34]|pdf|png|rar|rtf|swf|tar|tgz|txt|wav|woff|xml|zip|webm)(\?.*)?$") {
    unset beresp.http.set-cookie;
  }

  # Varnish 4 fully supports Streaming, so use streaming here to avoid locking.
  if (bereq.url ~ "^[^?]*\.(mp[34]|rar|tar|tgz|gz|wav|zip|bz2|xz|7z|avi|mov|ogm|mpe?g|mk[av]|webm)(\?.*)?$") {
    unset beresp.http.set-cookie;
    set beresp.do_stream = true;  # Check memory usage it'll grow in fetch_chunksize blocks (128k by default) if the backend doesn't send a Content-Length header, so only enable it for big objects
    set beresp.do_gzip = false;   # Don't try to compress it for storage
  }

  # Allow stale content, in case the backend goes down.
  # make Varnish keep all objects for 6 hours beyond their TTL
  set beresp.grace = 6h;

  unset beresp.http.Server;
  unset beresp.http.X-Powered-By;

  if (bereq.url ~ "wp-(login|admin)" || bereq.url ~ "preview=true") {
    set beresp.uncacheable = true;
    set beresp.ttl = 30s;
    return (deliver);
  }

  # Only allow cookies to be set if we're in admin area
  if (!(bereq.url ~ "(wp-login|wp-admin|preview=true)")) {
    unset beresp.http.set-cookie;
  }

  # don't cache response to posted requests or those with basic auth
  if ( bereq.method == "POST" || bereq.http.Authorization ) {
    set beresp.uncacheable = true;
    set beresp.ttl = 120s;
    return (deliver);
  }

  # don't cache search results
  if ( bereq.url ~ "\?s=" ){
    set beresp.uncacheable = true;
    set beresp.ttl = 120s;
    return (deliver);
  }

   # only cache status ok
  if ( beresp.status != 200 ) {
    set beresp.uncacheable = true;
    set beresp.ttl = 120s;
    return (deliver);
  }

   # A TTL of 2h
  set beresp.ttl = 2h;
  # Define the default grace period to serve cached content
  set beresp.grace = 30s;

  return (deliver);

}

sub vcl_deliver {
  # Happens when we have all the pieces we need, and are about to send the
  # response to the client.
  #
  # You can do accounting or modifying the final object here.

  # Called before a cached object is delivered to the client.

  if (obj.hits > 0) { # Add debug header to see if it's a HIT/MISS and the number of hits, disable when not needed
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }

  # Please note that obj.hits behaviour changed in 4.0, now it counts per objecthead, not per object
  # and obj.hits may not be reset in some cases where bans are in use. See bug 1492 for details.
  # So take hits with a grain of salt
  set resp.http.X-Cache-Hits = obj.hits;

  # Remove some headers: PHP version
  unset resp.http.X-Powered-By;

  # Remove some headers: Apache version & OS
  unset resp.http.Server;
  unset resp.http.X-Drupal-Cache;
  unset resp.http.X-Varnish;
  unset resp.http.X-Varnish;
  unset resp.http.Via;
  unset resp.http.Link;
  unset resp.http.X-Generator;

  set resp.http.Server = "HIT";

  return (deliver);

}

sub vcl_fini {
 	return (ok);
}

/*
 * We can come here "invisibly" with the following errors: 413, 417 & 503
 */
sub vcl_backend_error {
    set beresp.http.Content-Type = "text/html; charset=utf-8";
    set beresp.http.Retry-After = "5";
    synthetic( {"
	<html>
	<head>
	<title>Backend Unavailable</title>
	<style>
		body { background: #303030; text-align: center; color: white; }
		#page { border: 1px solid #CCC; width: 500px; margin: 100px auto 0; padding: 30px; background: #323232; }
		a, a:link, a:visited { color: #CCC; }
		.error { color: #222; }
	</style>
	</head>
		<body onload="setTimeout(function() { window.location = '/' }, 5000)">
		<div id="page">
		<h1 class="title">Page Unavailable</h1>
		<p>The page you requested is temporarily unavailable.</p>
 <h1>Error "} + beresp.status + " " + beresp.reason + {"</h1>
    <p>"} + beresp.reason + {"</p>
		<p>We're redirecting you to the <a href="/">homepage</a> in 5 seconds.</p>
		</div>
		</body>
	</html>
"} );
    return (deliver);
}

sub vcl_synth {
    set resp.http.Content-Type = "text/html; charset=utf-8";
    set resp.http.Retry-After = "5";
    if ( resp.status == 751 ) {
	   unset resp.http.X-Varnish;
	   if (!std.healthy(req.backend_hint)) {
		    set resp.status = 503;
	   } else {
		    set resp.status = 200;
	   }
synthetic( {"
<html>
  <head>
    <title>Health Check</title>
  <body>
    Health Check 
   <div class="error">(Error "} + resp.status + " " +  resp.reason + {")</div>
  </body>
</html>
"});
	    return(deliver);
    }

    synthetic( {"
	<html>
	<head>
	<title>Page Unavailable</title>
	<style>
		body { background: #303030; text-align: center; color: white; }
		#page { border: 1px solid #CCC; width: 500px; margin: 100px auto 0; padding: 30px; background: #323232; }
		a, a:link, a:visited { color: #CCC; }
		.error { color: #222; }
	</style>
	</head>
		<body onload="setTimeout(function() { window.location = '/' }, 5000)">
		<div id="page">
		<h1 class="title">Page Unavailable</h1>
		<p>The page you requested is temporarily unavailable.</p>
		<div class="error">(Error "} + resp.status + " " +  resp.reason + {")</div>
		<p>We're redirecting you to the <a href="/">homepage</a> in 5 seconds.</p>
		</div>
		</body>
	</html>
"} );
    return (deliver);
}


