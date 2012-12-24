#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=Pound
PKG_VERSION:=2.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tgz
PKG_SOURCE_URL:=http://www.apsis.ch/pound/
PKG_MD5SUM:=8a39f5902094619afcda7d12d9d8342c

PKG_BUILD_PARALLEL:=0
#PKG_FIXUP:=libtool

include $(INCLUDE_DIR)/package.mk

define Package/pound
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libopenssl +libpcre +libpthread 
  PKG_CONFIG_DEPENDS:= CONFIG_OPENSSL_THREADS 
  TITLE:=Pound load balancer and reverse proxy
  URL:=http://www.apsis.ch/pound/
endef

define Package/pound/description
        The Pound program is a reverse proxy, load balancer and HTTPS front-end for Web server(s).
        Pound was developed to enable distributing the load among several Web-servers and to allow 
        for a convenient SSL wrapper for those Web servers that do not offer it natively.
endef

define Package/pound/config
  select OPENSSL_THREADS
endef

define Package/pound/conffiles
/etc/pound.cfg
endef

CONFIGURE_VARS += \
	ac_cv_prog_CC="$(TARGET_CC)"  \
	ac_cv_prog_ac_ct_CC="$(TARGET_CC)"

CONFIGURE_ARGS+= \
  --without-threads \
  --with-ssl=$(STAGING_DIR)/usr \
  --prefix=/usr/sbin

define Build/Compile
	mkdir -p $(PKG_INSTALL_DIR)/etc/pound
	$(MAKE) -C $(PKG_BUILD_DIR) TPROXY=1 all
endef

define Package/pound/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/pound $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/poundctl $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/pound.init $(1)/etc/init.d/pound
	$(INSTALL_DATA) ./files/pound.cfg $(1)/etc/pound.cfg
endef

$(eval $(call BuildPackage,pound))
