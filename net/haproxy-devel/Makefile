#
# Copyright (C) 2010-2013 OpenWrt.org
# Copyright (C) 2009-2013 Thomas Heil <heil@terminal-consulting.de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=haproxy-devel
<<<<<<< HEAD
PKG_VERSION:=1.6.3
PKG_RELEASE:=67
PKG_SOURCE:=haproxy-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://haproxy.1wt.eu/download/1.6/src/
PKG_MD5SUM:=3362d1e268c78155c2474cb73e7f03f9
=======
PKG_VERSION:=1.6.2
PKG_RELEASE:=19
PKG_SOURCE:=haproxy-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://haproxy.1wt.eu/download/1.6/src/
PKG_MD5SUM:=d0ebd3d123191a8136e2e5eb8aaff039
>>>>>>> db12ef06fc837cd776769cb4fe14fdc67f434edb

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

define Download/lua532
	FILE:=lua-5.3.2.tar.gz
	URL:=http://www.lua.org/ftp/
	MD5SUM:=33278c2ab5ee3c1a875be8d55c1ca2a1
endef
$(eval $(call Download,lua532))

define Build/Prepare
	$(call Build/Prepare/Default)
	tar -zxvf $(DL_DIR)/lua-5.3.2.tar.gz -C $(PKG_BUILD_DIR)
	ln -s $(PKG_BUILD_DIR)/lua-5.3.2 $(PKG_BUILD_DIR)/lua
endef


define Package/haproxy-devel/conffiles
/etc/haproxy.cfg
endef

define Package/haproxy-devel/description
  Open source High Performance TCP/HTTP Load Balancer
endef

ifeq ($(CONFIG_avr32),y)
  LINUX_TARGET:=linux26
else
  LINUX_TARGET:=linux2628
endif

define Build/Compile
	make TARGET=$(LINUX_TARGET) -C $(PKG_BUILD_DIR)/lua INSTALL_TOP="$(STAGING_DIR)/lua532/" linux install 

	$(MAKE) TARGET=$(LINUX_TARGET) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fno-align-jumps -fno-align-functions -fno-align-labels -fno-align-loops -pipe -fomit-frame-pointer -fhonour-copts" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		ADDLIB="-lcrypto" \
		USE_LUA=1 \
		LUA_LIB_NAME="lua" \
		PCREDIR="$(STAGING_DIR)/usr/include" \
	        LUA_INC="$(STAGING_DIR)/lua532/include" \
		LUA_LIB="$(STAGING_DIR)/lua532/lib" \
		SMALL_OPTS="-DBUFSIZE=16384 -DMAXREWRITE=1030 -DSYSTEM_MAXCONN=165530 " \
		USE_LINUX_TPROXY=1 USE_LINUX_SPLICE=1 USE_REGPARM=1 USE_OPENSSL=1 \
		USE_ZLIB=yes USE_PCRE=1 \
		VERSION="$(PKG_VERSION)-patch$(PKG_RELEASE)" \
		IGNOREGIT=1 \
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
