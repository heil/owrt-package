# test
define KernelPackage/ipvs-core
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server Support
  KCONFIG:= \
        CONFIG_IP_VS \
        CONFIG_IP_VS_IPV6=y \
        CONFIG_IP_VS_PROTO_TCP=y \
        CONFIG_IP_VS_PROTO_UDP=y \
        CONFIG_IP_VS_PROTO_ESP=y \
        CONFIG_IP_VS_PROTO_AH=y \
        CONFIG_IP_VS_PROTO_SCTP=y \
        CONFIG_IP_VS_NFCT=y \
        CONFIG_IP_VS_DEBUG=n \
        CONFIG_IP_VS_TAB_BITS=12 \
        CONFIG_IP_VS_SH_TAB_BITS=8 \
        CONFIG_NETFILTER_XT_MATCH_IPVS=n
  DEPENDS:=+kmod-ipt-core +kmod-lib-crc32c +ip6tables
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs.ko
  AUTOLOAD:=$(call AutoLoad,60,ip_vs)
endef

define KernelPackage/ipvs-core/description
 Kernel modules core support for Linux Virtual Server
endef

$(eval $(call KernelPackage,ipvs-core))

define KernelPackage/ipvs-rr
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server Round Robin Scheduler
  KCONFIG:= \
     CONFIG_IP_VS_RR
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_rr.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_rr)
endef

define KernelPackage/ipvs-rr/description
 The robin-robin scheduling algorithm simply directs network
endef

$(eval $(call KernelPackage,ipvs-rr))

define KernelPackage/ipvs-wrr
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server weighted round robin scheduler
  KCONFIG:= \
        CONFIG_IP_VS_WRR
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_wrr.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_wrr)
endef

define KernelPackage/ipvs-wrr/description
 The robin-robin scheduling algorithm with weights
endef

$(eval $(call KernelPackage,ipvs-wrr))

define KernelPackage/ipvs-lc
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server least connections scheduler
  KCONFIG:= \
        CONFIG_IP_VS_LC
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_lc.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_lc)
endef

define KernelPackage/ipvs-lc/description
 The least-connection scheduling algorithm directs network
 connections to the server with the least number of active
 connections
endef

$(eval $(call KernelPackage,ipvs-lc))

define KernelPackage/ipvs-wlc
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server weighted least connections scheduler
  KCONFIG:= \
        CONFIG_IP_VS_WLC
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_wlc.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_wlc)
endef

define KernelPackage/ipvs-wlc/description
 The least-connection scheduling algorithm directs network
 connections to the server with the least connections with
 normalized by the server weight
endef

$(eval $(call KernelPackage,ipvs-wlc))

define KernelPackage/ipvs-lblc
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server locality based connections scheduler
  KCONFIG:= \
        CONFIG_IP_VS_LBLC
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_lblc.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_lblc)
endef

define KernelPackage/ipvs-lblc/description
 The locality-based least-connection scheduling algorithm is for
 destination IP load balancing. It is usually used in cache cluster
 This algorithm usually directs packet destined for an IP address to
 its server if the server is alive and under load. If the server is
 overloaded (its active connection numbers is larger than its weight)
 and there is a server in its half load, then allocate the weighted
 least-connection server to this IP address.
endef

$(eval $(call KernelPackage,ipvs-lblc))

define KernelPackage/ipvs-lblcr
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server locality based with replication
  KCONFIG:= \
        CONFIG_IP_VS_LBLCR
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_lblcr.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_lblcr)
endef

define KernelPackage/ipvs-lblcr/description
 The locality-based least-connection with replication scheduling
 algorithm is also for destination IP load balancing. It is
 usually used in cache cluster. It differs from the LBLC
 scheduling as follows: the load balancer maintains mappings from a target
 to a set of server nodes that can serve the target. Requests
 for a target are assigned to the least-connection node in the target's
 server set. If all the node in the server set are over
 loaded, it picks up a least-connection node in the cluster and adds it
 in the sever set for the target. If the server set has not been
 modified for the specified time, the most loaded node is
 removed from the server set, in order to avoid high degree of replication
endef

$(eval $(call KernelPackage,ipvs-lblcr))

define KernelPackage/ipvs-dh
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server destination hashing scheduler
  KCONFIG:= \
        CONFIG_IP_VS_DH
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_dh.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_dh)
endef

define KernelPackage/ipvs-dh/description
 The destination hashing scheduling algorithm assigns network
 connections to the servers through looking up a statically assigned
 hash table by their destination IP addresses
endef

$(eval $(call KernelPackage,ipvs-dh))

define KernelPackage/ipvs-sh
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server source hashing scheduler
  KCONFIG:= \
        CONFIG_IP_VS_SH
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_sh.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_sh)
endef

define KernelPackage/ipvs-sh/description
 The source hashing scheduling algorithm assigns network
 connections to the servers through looking up a statically assigned
 hash table by their source IP addresses
endef

$(eval $(call KernelPackage,ipvs-sh))

define KernelPackage/ipvs-sed
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server shortest expected delay scheduling
  KCONFIG:= \
        CONFIG_IP_VS_SED
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_sed.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_sed)
endef

define KernelPackage/ipvs-sed/description
 The shortest expected delay scheduling algorithm assigns network
 connections to the server with the shortest expected delay. The
 expected delay that the job will experience is (Ci + 1) / Ui if
 sent to the ith server, in which Ci is the number of connections
 on the ith server and Ui is the fixed service rate (weight)
 of the ith server.
endef

$(eval $(call KernelPackage,ipvs-sed))

define KernelPackage/ipvs-nq
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server never queuing scheduling
  KCONFIG:= \
        CONFIG_IP_VS_NQ
  DEPENDS:=+kmod-ipvs-core
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_nq.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_nq)
endef

define KernelPackage/ipvs-nq/description
 The never queue scheduling algorithm adopts a two-speed model.
 When there is an idle server available, the job will be sent to
 the idle server, instead of waiting for a fast one. When there
 is no idle server available, the job will be sent to the server
 that minimize its expected delay (The Shortest Expected Delay
 scheduling algorithm)
endef

$(eval $(call KernelPackage,ipvs-nq))

define KernelPackage/ipvs-ftp
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server FTP protocol helper
  KCONFIG:= \
        CONFIG_IP_VS_FTP
  DEPENDS:=+kmod-ipvs-core +kmod-ipt-nat +kmpd-ipt-nat6
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_ftp.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_ftp)
endef

define KernelPackage/ipvs-ftp/description
 FTP is a protocol that transfers IP address and/or port number in
 the payload. In the virtual server via Network Address Translation,
 the IP address and port number of real servers cannot be sent to
 clients in ftp connections directly, so FTP protocol helper is
 required for tracking the connection and mangling it back to that of
 virtual service.
endef

$(eval $(call KernelPackage,ipvs-ftp))

define KernelPackage/ipvs-pe-sip
  SUBMENU:=$(NF_MENU)
  TITLE:=IP Virtual Server SIP persistence engine
  KCONFIG:= \
        CONFIG_IP_VS_PE_SIP
  DEPENDS:=+kmod-ipvs-core +kmod-ipt-nathelper-extra
  FILES:=$(LINUX_DIR)/net/netfilter/ipvs/ip_vs_pe_sip.ko
  AUTOLOAD:=$(call AutoLoad,61,ip_vs_pe_sip)
endef

define KernelPackage/ipvs-pe-sip/description
 Allow persistence based on the SIP Call-I
endef

$(eval $(call KernelPackage,ipvs-pe-sip))

define KernelPackage/ipt-CLUSTERIP
  TITLE:=CLUSTERIP SUPPORT
  DEPENDS+=+IPV6:kmod-ipv6
  KCONFIG:= \
        CONFIG_IP_NF_TARGET_CLUSTERIP \
        CONFIG_NETFILTER_XT_MATCH_CLUSTER
  FILES:= \
        $(LINUX_DIR)/net/ipv4/netfilter/ipt_CLUSTERIP.ko \
        $(LINUX_DIR)/net/netfilter/xt_cluster.ko
  AUTOLOAD:=$(call AutoLoad,61,ipt_CLUSTERIP xt_cluster )
  $(call AddDepends/ipt)
endef

define KernelPackage/ipt-CLUSTERIP/description
  Kernel modules for Transparent Proxying
endef

$(eval $(call KernelPackage,ipt-CLUSTERIP))

