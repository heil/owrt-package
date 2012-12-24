#
# Copyright (C) 2010 OpenWrt.org
# Copyright (C) 2009-2010 Thomas Heil <heil@terminal-consulting.de> 
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ipvsadm
PKG_VERSION:=1.26
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.LinuxVirtualServer.org/software/kernel-2.6
PKG_MD5SUM:=eac3ba3f62cd4dea2da353aeddd353a8

include $(INCLUDE_DIR)/package.mk

define Package/ipvsadm
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Utility to administer the Linux Virtual Server
  URL:=http://www.LinuxVirtualServer.org
  DEPENDS:=+libpcre +libltdl +libpopt +libnl 
#+libnl-tiny 
endef

define Package/ipvsadm/conffiles
/etc/ipvsadm.cfg
endef

define Package/ipvsadm/description
  ipvsadm is a utility to administer the IP Virtual Server services
  offered by the latest Linux kernel 2.6.x.
endef

#TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/libnl-tiny -L$(STAGING_DIR)/usr/lib  -DLIBIPVS_USE_NL -lnl-tiny -lnl-genl
TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include -L$(STAGING_DIR)/usr/lib  -DLIBIPVS_USE_NL -lnl-genl

define Build/Compile
        $(MAKE) -C $(PKG_BUILD_DIR)/ \
        LIBDIR="$(TARGET_LDFLAGS)" \
        CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_CPPFLAGS) -std=gnu99" 
endef

define Package/ipvsadm/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ipvsadm $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/ipvsadm-save $(1)/usr/sbin/
	chmod 0750 $(1)/usr/sbin/ipvsadm-save
	$(INSTALL_BIN) ./files/ipvsadm-restore $(1)/usr/sbin/
	chmod 0750 $(1)/usr/sbin/ipvsadm-restore
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libipvs/libipvs.so $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./files/ipvsadm.rules $(1)/etc/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/ipvsadm.init $(1)/etc/init.d/ipvsadm
	chmod 0750 $(1)/etc/init.d/ipvsadm
endef

$(eval $(call BuildPackage,ipvsadm))
