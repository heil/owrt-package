# Copyright 2011 Bump Technologies, Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice, this list of
#      conditions and the following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above copyright notice, this list
#      of conditions and the following disclaimer in the documentation and/or other materials
#      provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY BUMP TECHNOLOGIES, INC. ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BUMP TECHNOLOGIES, INC. OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are those of the
# authors and should not be interpreted as representing official policies, either expressed
# or implied, of Bump Technologies, Inc.

include $(TOPDIR)/rules.mk

PKG_NAME:=stud
PKG_VERSION:=0.3.31
PKG_RELEASE:=1
PKG_REV:=19a7f19686bcdbd689c6fbea31f68a276e62d886

PKG_SOURCE:=stud-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=stud-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/bumptech/stud.git
PKG_SOURCE_VERSION:=$(PKG_REV)
PKG_SOURCE_PROTO:= git

include $(INCLUDE_DIR)/package.mk

define Package/stud
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  TITLE:=The Scalable TLS Unwrapping Daemon
  URL:=https://github.com/bumptech/stud
  DEPENDS:=+libpcre +libev +libopenssl +librt
  MAINTAINER:=Thomas Heil <heil@terminal-consulting.de>
endef

define Download/ebtree
  FILE:=ebtree-6.0.8.tar.gz
  URL:=http://1wt.eu/tools/ebtree/
  EBTREE=$(FILE)
  MD5SUM:=60655c583f928ba494d2b7dc7b09a163
endef
$(eval $(call Download,ebtree))


define Package/stud/conffiles
/etc/stud.cfg
endef

define Package/stud/description
  Scalable TLS Unwrapping Daemon
endef

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include -I$(STAGING_DIR)/usr/include/libev -lev -lssl -I$(STAGING_DIR)/usr/include/openssl
TARGET_CFLAGS += $(FPIC) -std=gnu99 
TARGET_LDFLAGS += -lev -lssl -lcrypto  -L$(STAGING_DIR)/usr/lib/libev -L$(STAGING_DIR)/usr/lib -lpthread -lrt

define Build/Prepare
	$(call Build/Prepare/Default)
	tar -zxvf $(DL_DIR)/ebtree-6.0.8.tar.gz -C $(PKG_BUILD_DIR)
	ln -s $(PKG_BUILD_DIR)/ebtree-6.0.8 $(PKG_BUILD_DIR)/ebtree
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		USE_SHARED_CACHE=1  \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -DUSE_SHARED_CACHE=1" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		NO_CONFIG_FILE=1  \
		all 
endef

define Package/stud/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/stud $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/config.stud $(1)/etc/config/stud
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/init.stud $(1)/etc/init.d/stud
	$(INSTALL_DIR) $(1)/etc/hotplug.d/net
	$(INSTALL_BIN) ./files/stud.hotplug $(1)/etc/hotplug.d/net/90-stud
endef

$(eval $(call BuildPackage,stud))
