#
# Copyright (C) 2010-2011 OpenWrt.org
# Copyright (C) 2009-2010 Thomas Heil <heil@terminal-consulting.de> 
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=httpterm
PKG_VERSION:=1.7.2
PKG_RELEASE:=1

PKG_SOURCE:=httpterm-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://1wt.eu/tools/httpterm/
PKG_MD5SUM:=531c0a83c5a6e75cb4b8eb212b56492c

include $(INCLUDE_DIR)/package.mk

define Package/httpterm
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  TITLE:= HTTP termination for benchmark
  URL:=http://1wt.eu/tools/httpterm
  DEPENDS:=+libpcre +libltdl
  MAINTAINER:=Thomas Heil <heil@terminal-consulting.de>
endef

define Package/httpterm/conffiles
/etc/httpterm.cfg
endef

define Package/httpterm/description
  Open source High Performance TCP/HTTP Load Balancer
endef

define Build/Compile
	$(MAKE) TARGET=linux26 -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -O2 -march=x86-64 -pipe -fomit-frame-pointer -fno-strict-aliasing" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		SMALL_OPTS="-DBUFSIZE=8030 -DMAXREWRITE=1030 -DSYSTEM_MAXCONN=65530" \
		all 
endef

define Package/httpterm/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/httpterm $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/httpterm.cfg $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/httpterm.init $(1)/etc/init.d/httpterm
endef

$(eval $(call BuildPackage,httpterm))
