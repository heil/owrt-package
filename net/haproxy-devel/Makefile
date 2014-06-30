#
# Copyright (C) 2010-2013 OpenWrt.org
# Copyright (C) 2009-2013 Thomas Heil <heil@terminal-consulting.de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=haproxy-devel
PKG_VERSION:=1.6-dev0
PKG_RELEASE:=17
PKG_SOURCE:=haproxy-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://haproxy.1wt.eu/download/1.6/src/devel
PKG_MD5SUM:=eb5026b8ae3529fe7201f52896523f67

PKG_BUILD_DIR:=$(BUILD_DIR)/haproxy-$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=haproxy-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/haproxy-devel
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  TITLE:=The Reliable, High Performance TCP/HTTP Load Balancer
  URL:=http://haproxy.1wt.eu/
  DEPENDS:=+libpcre +libltdl +libopenssl +zlib +libpthread
  MAINTAINER:=Thomas Heil <heil@terminal-consulting.de>
endef

define Package/haproxy-devel/conffiles
/etc/haproxy.cfg
endef

define Package/haproxy-devel/description
  Open source High Performance TCP/HTTP Load Balancer
endef

define Build/Compile
	$(MAKE) TARGET=linux2628 -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fno-align-jumps -fno-align-functions -fno-align-labels -fno-align-loops -pipe -fomit-frame-pointer -fhonour-copts" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		ADDLIB="-lcrypto" \
		PCREDIR="$(STAGING_DIR)/usr/include" \
		SMALL_OPTS="-DBUFSIZE=16384 -DMAXREWRITE=1030 -DSYSTEM_MAXCONN=165530 " \
		USE_LINUX_TPROXY=1 USE_LINUX_SPLICE=1 USE_REGPARM=1 USE_OPENSSL=1 \
		USE_ZLIB=yes USE_PCRE=1 \
		VERSION="$(PKG_VERSION)-patch$(PKG_RELEASE)" \
		install

	$(MAKE) -C $(PKG_BUILD_DIR)/contrib/halog \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fno-align-jumps -fno-align-functions -fno-align-labels -fno-align-loops -pipe -fomit-frame-pointer -fhonour-copts" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		ADDLIB="-lcrypto" \
		VERSION="$(PKG_VERSION)-patch$(PKG_RELEASE)" \
		halog
endef

define Package/haproxy-devel/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/haproxy $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/haproxy.cfg $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/haproxy.init $(1)/etc/init.d/haproxy
	$(INSTALL_DIR) $(1)/etc/hotplug.d/net
	$(INSTALL_BIN) ./files/haproxy.hotplug $(1)/etc/hotplug.d/net/90-haproxy
endef

define Package/halog-devel
	MENU:=1
	$(call Package/haproxy-devel)
	TITLE+= halog-devel
	DEPENDS:=haproxy-devel
endef

define Package/halog-devel/description
	HAProxy Log Analyzer
endef

define Package/halog-devel/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/contrib/halog/halog $(1)/usr/bin/
endef

$(eval $(call BuildPackage,haproxy-devel))
$(eval $(call BuildPackage,halog-devel))
