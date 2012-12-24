# 
# Copyright (C) 2006-2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kbd
PKG_RELEASE:=1
PKG_VERSION:=1.15.3
PKG_SOURCE_URL:=http://ftp.altlinux.org/pub/people/legion/kbd/
#PKG_SOURCE_URL:=http://ftp.uni-frankfurt.de/kernel/linux/utils/kbd/
PKG_SOURCE:=kbd-$(PKG_VERSION).tar.gz
PKG_MD5SUM:=8143e179a0f3c25646ce5085e8777200

include $(INCLUDE_DIR)/package.mk

define Package/kbd/Default
  SECTION:=utils
  CATEGORY:=Utilities
  URL:=ftp://ftp.kernel.org/pub/linux/utils/kbd
endef

define Package/kbd
  $(call Package/kbd/Default)
  TITLE:=Keyboard and console utilities for Linux
endef

define Package/kbd-console-fonts
  $(call Package/kbd/Default)
  TITLE:=Console fonts for Linux
endef

define Package/kbd-console-maps
  $(call Package/kbd/Default)
  TITLE:=Console maps for Linux
endef

define Package/kbd/description
  Keyboard and console utilities for Linux
endef

define Build/Configure
	( cd $(PKG_BUILD_DIR) ; aclocal; autoheader; automake; autoconf )
	$(call Build/Configure/Default, CFLAGS=-Wno-cast-align )
endef

define Package/kbd/install
	$(INSTALL_DIR) $(1)/usr/bin
	for f in setfont psfxtable setmetamode unicode_stop kbdrate loadkeys kbd_mode showconsolefont loadunimap unicode_start deallocvt openvt getkeycodes showkey setleds cad chvt mapscrn fgconsole setkeycodes dumpkeys; do \
            $(INSTALL_BIN) $(PKG_BUILD_DIR)/src/$$$$f $(1)/usr/bin;\
	done
endef

define Package/kbd-console-fonts/install
	$(INSTALL_DIR) $(1)/usr/share/kbd/consolefonts
	$(CP) $(PKG_BUILD_DIR)/data/consolefonts/* $(1)/usr/share/kbd/consolefonts/
endef

define Package/kbd-console-maps/install
	$(INSTALL_DIR) $(1)/usr/share/kbd/keymaps/
	$(CP) $(PKG_BUILD_DIR)/data/keymaps/i386/ $(1)/usr/share/kbd/keymaps/
	$(INSTALL_DIR) $(1)/usr/share/kbd/keymaps/include
	$(CP) $(PKG_BUILD_DIR)/data/keymaps/include/* $(1)/usr/share/kbd/keymaps/include/
endef

$(eval $(call BuildPackage,kbd))
$(eval $(call BuildPackage,kbd-console-fonts))
$(eval $(call BuildPackage,kbd-console-maps))
