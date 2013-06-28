#
# Copyright (C) 2010-2013 OpenWrt.org
# Copyright (C) 2009-2013 Thomas Heil <heil@terminal-consulting.de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gradm
PKG_VERSION:=2.9.1-201301041755
PKG_RELEASE:=1
PKG_SOURCE:=gradm-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://grsecurity.net/stable/
PKG_MD5SUM:=ea634c5a83bfbe1fcde7c6f92e869c99

PKG_BUILD_DIR:=$(BUILD_DIR)/gradm2
PKG_SOURCE_SUBDIR:=gradm2

include $(INCLUDE_DIR)/package.mk

define Package/gradm
  SECTION:=net
  CATEGORY:=Utilities
  TITLE:=GRADM
  URL:=http://grsecurity.net/stable/
  DEPENDS:=+libpcre +libltdl +libopenssl +zlib +libpthread
  MAINTAINER:=Thomas Heil <heil@terminal-consulting.de>
endef

define Package/gradm/conffiles
/etc/grsec
endef

define Package/gradm/description
 RBAC-based ACL-System to manage grsecurity2
endef

define Build/Compile
	$(MAKE) nopam -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fno-align-jumps -fno-align-functions -fno-align-labels -fno-align-loops -pipe -fomit-frame-pointer -fhonour-copts -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DFILE_OFFSET_BITS=64" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		install

endef

define Package/gradm/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/sbin/gradm $(1)/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/sbin/grlearn $(1)/sbin/
	$(INSTALL_DIR) $(1)/etc/grsec
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/grsec/policy $(1)/etc/grsec/policy
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/grsec/learn_config $(1)/etc/grsec/learn_config
endef

define Package/gradm/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
        echo "try to create /dev/grsec"
        /bin/mknod /dev/grsec c 1 13
        exit 0
}
endef

$(eval $(call BuildPackage,gradm))
