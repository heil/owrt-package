#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=varnish-devel
PKG_VERSION:=4.1.0
PKG_RELEASE:=1

PKG_SOURCE:=varnish-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://repo.varnish-cache.org/source/
PKG_MD5SUM:=d93e32b59c0c7487180a37781aae13f7

PKG_BUILD_DIR:=$(BUILD_DIR)/varnish-$(PKG_VERSION)
PKG_SOURCE_SUBDIR:=varnish-$(PKG_VERSION)


PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/varnish-devel
  SUBMENU:=Web Servers/Proxies
  SECTION:=net
  CATEGORY:=Network
  TITLE:=VARNISH CACHE 4.1.x make Websites fly
  URL:=http://www.varnish-cache.org/
  DEPENDS:=+libpcre +libltdl +libncurses +logrotate +librt +bash +gcc-native +zlib  +libelf +libreadline +libncursesw
endef

define Package/varnish-devel/description
  Open source Website Cache
endef

CONFIGURE_VARS += \
	ac_cv_so_rcvtimeo_works=no \
	ac_cv_so_sndtimeo_works=no \
	ac_cv_so_sendfile_works=no \
	ac_cv_lib_jemalloc_malloc_conf=no \
	ac_cv_have_tcp_keep=yes \
	ac_cv_have_viz=no \
	VCC_CC="varnishcc %s %o" 

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

	mkdir -p $(PKG_INSTALL_DIR)/etc
	$(CP) $(PKG_BUILD_DIR)/etc/builtin.vcl $(PKG_INSTALL_DIR)/etc

	$(MAKE) -C $(PKG_BUILD_DIR)/bin/varnishtop \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LD="$(TARGET_CC)" \
		LDFLAGS="$(TARGET_LDFLAGS) -lpcre -lpthread" \
		DESTDIR="$(PKG_INSTALL_DIR)" \
	install
endef

define Package/varnish-devel/conffiles
/etc/varnish/default.vcl
/etc/config/varnish
endef

define Package/varnish-devel/install
	$(INSTALL_DIR) $(1)/etc/varnish
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/builtin.vcl $(1)/etc/varnish
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
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishstat $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishtest $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/varnishd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/varnish
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/*.so* $(1)/usr/lib/
	#$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/*.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/varnish
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/varnish/*.so* $(1)/usr/lib/varnish
	#$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/varnish/*.a $(1)/usr/lib/varnish 
	$(INSTALL_DIR) $(1)/usr/lib/varnish/vmods
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/varnish/vmods/* $(1)/usr/lib/varnish/vmods
	$(INSTALL_BIN) ./files/pts-tcc $(1)/usr/bin
	chmod 0750 $(1)/usr/bin/pts-tcc
	$(INSTALL_BIN) ./files/varnishcc $(1)/usr/bin/varnishcc
	chmod 0750 $(1)/usr/bin/varnishcc
endef

define Package/varnish-devel-top
	MENU:=1
	$(call Package/varnish-devel)
	TITLE+= varnish-devel-top)
	DEPENDS:=varnish-devel
endef

define Package/varnish-devel-top/description
	varnishtop top for varnish-devel
endef

define Package/varnish-devel-top/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/varnishtop $(1)/usr/bin/
endef

$(eval $(call BuildPackage,varnish-devel))
$(eval $(call BuildPackage,varnish-devel-top))
