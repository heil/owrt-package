#
# Copyright (C) 2010-2013 OpenWrt.org
# Copyright (C) 2009-2013 Thomas Heil <heil@terminal-consulting.de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=haproxy-devel
PKG_VERSION:=1.6-dev4
PKG_RELEASE:=02
PKG_SOURCE:=haproxy-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://haproxy.1wt.eu/download/1.6/src/devel
PKG_MD5SUM:=bb300d99f0ac6114dc997f277d80e5d1

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

define Download/lua531
	FILE:=lua-5.3.1.tar.gz
	URL:=http://www.lua.org/ftp/
	EBTREE=$(FILE)
	MD5SUM:=797adacada8d85761c079390ff1d9961
endef
$(eval $(call Download,lua531))

define Build/Prepare
	$(call Build/Prepare/Default)
	tar -zxvf $(DL_DIR)/lua-5.3.1.tar.gz -C $(PKG_BUILD_DIR)
	ln -s $(PKG_BUILD_DIR)/lua-5.3.1 $(PKG_BUILD_DIR)/lua
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
	make TARGET=$(LINUX_TARGET) -C $(PKG_BUILD_DIR)/lua INSTALL_TOP="$(STAGING_DIR)/lua531/" linux install 

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
	        LUA_INC="$(STAGING_DIR)/lua531/include" \
		LUA_LIB="$(STAGING_DIR)/lua531/lib" \
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
