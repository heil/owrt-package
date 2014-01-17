#
# Copyright (C) 2010-2013 OpenWrt.org
# Copyright (C) 2009-2013 Thomas Heil <heil@terminal-consulting.de>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=paxctl
PKG_VERSION:=0.7
PKG_RELEASE:=1
PKG_SOURCE:=paxctl-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://pax.grsecurity.net/
PKG_MD5SUM:=25bf9df751976e87be20243e75291263

#PKG_BUILD_DIR:=$(BUILD_DIR)/paxctl2
#PKG_SOURCE_SUBDIR:=paxctl2

include $(INCLUDE_DIR)/package.mk

define Package/paxctl
  SECTION:=net
  CATEGORY:=Utilities
  TITLE:=paxctl
  URL:=http://pax.grsecurity.net/
  DEPENDS:=+libpcre +libltdl +libopenssl +zlib +libpthread
  MAINTAINER:=Thomas Heil <heil@terminal-consulting.de>
endef

define Package/paxctl/description
 Pax Control Utility
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fno-align-jumps -fno-align-functions -fno-align-labels -fno-align-loops -pipe -fomit-frame-pointer -fhonour-copts -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DFILE_OFFSET_BITS=64" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		install

endef

define Package/paxctl/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/sbin/paxctl $(1)/sbin/
endef

$(eval $(call BuildPackage,paxctl))
