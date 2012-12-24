#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=varnish
PKG_VERSION:=3.0.3
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://repo.varnish-cache.org/source/
PKG_MD5SUM:=714310c83fdbd2061d897dacd3f63d8b
#PKG_MD5SUM:=c8eae0aabbe66b6daabdf3a1f58cd47a
#PKG_MD5SUM:=38387bf31a1574f5cd8dec4f0b7caf20
#PKG_MD5SUM:=2d2f227da36a2a240c475304c717b8e3

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/varnish
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  TITLE:=VARNISH CACHE make Websites fly
  URL:=http://www.varnish-cache.org/
  DEPENDS:=+libpcre +libltdl +libncurses +logrotate +librt +bash +gcc-native +zlib  +libelf
endef

define Package/varnish/description
  Open source Website Cache
endef

CONFIGURE_VARS += \
	ac_cv_so_rcvtimeo_works=no \
	ac_cv_so_sndtimeo_works=no \
	ac_cv_so_sendfile_works=no \
	ac_cv_lib_jemalloc_malloc_conf=no \
	ac_cv_have_viz=no \
	VCC_CC="varnishcc %s %o" 

#TARGET_CFLAGS += -std=gnu99
#-ggdb3

CONFIGURE_ARGS := \
	$(filter-out --disable-nls,$(CONFIGURE_ARGS)) \
	--program-transform-name=""

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -std=gnu99" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS) -lpcre -lpthread" \
		DESTDIR="$(PKG_INSTALL_DIR)" \
	install

	$(MAKE) -C $(PKG_BUILD_DIR)/bin/varnishtop \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS) -lpcre -lpthread" \
		DESTDIR="$(PKG_INSTALL_DIR)" \
	install
endef

define Package/varnish/conffiles
/etc/varnish/default.vcl
endef

define Package/varnish/install
	$(INSTALL_DIR) $(1)/etc/varnish
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/varnish/default.vcl $(1)/etc/varnish
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_CONF) ./files/varnish.init $(1)/etc/init.d/varnish
	chmod 0750 $(1)/etc/init.d/varnish
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/varnish.config $(1)/etc/config/varnish
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishadm $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishhist $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishlog $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishncsa $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishreplay $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishsizes $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishstat $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishtest $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/varnishd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/varnish
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/*.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/varnish
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/varnish/*.so* $(1)/usr/lib/varnish
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/varnish/*.a $(1)/usr/lib/varnish 
	$(INSTALL_DIR) $(1)/usr/lib/varnish/vmods
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/varnish/vmods/* $(1)/usr/lib/varnish/vmods
	$(INSTALL_BIN) ./files/pts-tcc $(1)/usr/bin
	chmod 0750 $(1)/usr/bin/pts-tcc
	$(INSTALL_BIN) ./files/varnishcc $(1)/usr/bin/varnishcc
	chmod 0750 $(1)/usr/bin/varnishcc
endef

define Package/varnish-top
	MENU:=1
	$(call Package/varnish)
	TITLE+= varnish-top)
	DEPENDS:=varnish
endef

define Package/varnish-top/description
	varnishtop top for varnish
endef

define Package/varnish-top/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishtop $(1)/usr/bin/
endef

$(eval $(call BuildPackage,varnish))
$(eval $(call BuildPackage,varnish-top))
#VCC_CC="i686-gcc -L/lib -L/usr/lib -fpic -shared -Wl,-x -o %o %s" 
