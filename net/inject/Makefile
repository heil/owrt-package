#
# Copyright (C) 2010 OpenWrt.org
# Copyright (C) 2009-2010 Thomas Heil <heil@terminal-consulting.de> 
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=inject
PKG_VERSION:=3.6
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://nd-build-01.linux-appliance.net/tools/inject
PKG_MD5SUM:=eed11a8407478fb52673ce43dbfcf0bd

include $(INCLUDE_DIR)/package.mk

define Package/inject
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Utility to inject http traffic
  URL:=http://1wt.eu/tools/inject
endef

define Package/inject/conffiles
/etc/inject.cfg
endef

define Package/inject/description
  inject is simple http injector
endef


define Build/Compile
        $(MAKE) -C $(PKG_BUILD_DIR)/ \
        CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -std=gnu99" 
endef

define Package/inject/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/inject $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/injectl4 $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,inject))
