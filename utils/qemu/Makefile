#
# Copyright (C) 2009, 2010 Stefan Monnier
#
# This is free software, licensed under the GNU General Public License v3+.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qemu
PKG_VERSION:=1.3.0
PKG_RELEASE:=1
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:=http://wiki.qemu.org/download/
PKG_REV:=a4030ddd2ba324152a97d65d3c0b247d

##PKG_SOURCE_SUBDIR:=qemu-$(PKG_VERSION)
##PKG_SOURCE_URL:=git://git.qemu.org/qemu.git
##PKG_SOURCE_VERSION:=$(PKG_REV)
##PKG_SOURCE_PROTO:= git

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/qemu
  $(call Package/qemu/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=KVM Hypervisor
  #DEPENDS:=+zlib +libpthread +librt +libc +libgcc +libc +kmod-kvm-intel +kmod-kvm-amd +glib2
  DEPENDS:=+zlib +librt +libc +libgcc +libc +kmod-kvm-intel +kmod-kvm-amd +glib2 +libaio +bluez-libs +libcurl +libiconv-full +libncurses \
   +libjpeg +libpng +libffmpeg-full
endef

define Package/qemu/description
  This is qemu, the Hypervisor
endef

TARGET_LDFLAGS += $(FPIC)

TARGET_LDFLAGS += -L$(STAGING_DIR)/usr/lib/libiconv-full/lib -L$(STAGING_DIR)/usr/lib -lc -lrt -lavcodec 
#	--disable-linux-aio \
#	--disable-pie \
#	--disable-fdt \
#	--disable-attr \
#	--disable-nptl \
#	--with-coroutine=gthread \
#	--enable-vnc-thread \
#	--disable-vhost-net \

CONFIGURE_ARGS= \
	--cross-prefix="$(CROSS_PREFIX)" \
	--enable-kvm  \
	--disable-werror \
	--target-list=i386-softmmu,x86_64-softmmu,x86_64-linux-user,i386-linux-user \
	--prefix=/usr \
	--sysconfdir=/etc \
	--disable-docs \
	--disable-brlapi \
	--disable-vnc-sasl \
	--enable-linux-aio \
	--enable-nptl \
	--enable-pie \
	--enable-vhost-net \
	--extra-ldflags=-lm \
	--disable-sdl

#CONFIGURE_ARGS= \
#	--cross-prefix="$(CROSS_PREFIX)" \
#	--enable-kvm  \
#	--disable-werror \
#	--target-list=i386-softmmu,x86_64-softmmu \
#	--disable-pie \
#	--prefix=/usr 
#	--with-coroutine=gthread \

#define Build/Compile
#endef

#define Build/Compile
#        $(MAKE) -C $(PKG_BUILD_DIR) \
#		check-unit 
#endef

define Package/qemu/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/qemu* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/share/qemu
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/share/qemu/*.bin $(1)/usr/share/qemu/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/share/qemu/*.rom $(1)/usr/share/qemu/
	$(INSTALL_DIR) $(1)/usr/share/qemu/keymaps
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/share/qemu/keymaps/* $(1)/usr/share/qemu/keymaps/
	$(INSTALL_DIR) $(1)/etc/qemu
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/etc/qemu/target*  $(1)/etc/qemu/
endef

define Package/qemu/conffiles
/etc/lvm/lvm.conf
endef

$(eval $(call BuildPackage,qemu))
