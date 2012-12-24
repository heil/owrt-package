#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=e1000e-devel
PKG_VERSION:=2.1.4
PKG_RELEASE:=1

PKG_SOURCE:=e1000e-2.1.4.tar.gz
PKG_SOURCE_URL:=http://sourceforge.net/projects/e1000/files/e1000e/stable/2.1.4/
PKG_MD5SUM:=e8dba81bfc86c6c75f39d025fb70899f
#PKG_MD5SUM:=4e15b4ffd829496eb3baec97487c60ec
#PKG_MD5SUM:=96ce1d4116ae26d39a1a4cf950d47e54

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define KernelPackage/e1000e-devel
  SUBMENU:=Network Devices
  TITLE:=Intel e1000e devel ethernet driver
  FILES:= \
	$(PKG_BUILD_DIR)/e1000e-2.1.4/src/e1000e.ko
  AUTOLOAD:=$(call AutoLoad,40,e100e e1000edevel)
endef

TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include/old 

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	tar xzvf $(DL_DIR)/$(PKG_SOURCE) -C $(PKG_BUILD_DIR)/
	$(Build/Patch)
endef

define Build/Compile
	$(MAKE) -C "$(PKG_BUILD_DIR)/e1000e-2.1.4/src/" \
		KSRC="$(LINUX_DIR)" \
		KOBJ="$(LINUX_DIR)" \
		ARCH="$(LINUX_KARCH)" \
		ARCHIVER="$(TARGET_CROSS)ar" \
		COMPILER="$(TARGET_CC)" \
		LINKER="$(TARGET_CROSS)ld" \
		CFLAGS="$(TARGET_CFLAGS)" \
		CROSS_COMPILE="$(TARGET_CROSS)"
endef

define KernelPackage/e1000e-devel/install
endef

$(eval $(call KernelPackage,e1000e-devel))

