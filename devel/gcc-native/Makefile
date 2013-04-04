# 
# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=gcc

ifeq ($(shell $(TARGET_CC) -v 2>&1 | grep -q 'Linaro GCC' && echo y),y)
  GCC_VERSION:=$(shell $(TARGET_CC) -v 2>&1 | sed -ne 's/^gcc version \([^[:space:]]\+\) .*/\1/p')
  #GCC_VERSION:=4.5-2011.08
  PKG_VERSION:=$(shell $(TARGET_CC) -v 2>&1 | sed -ne 's/.*Linaro GCC \([^()]\+\).*/\1/p')
  #PKG_VERSION:=4.5-2011.08
  PKG_SOURCE:=gcc-linaro-$(PKG_VERSION).tar.bz2
  PKG_SOURCE_URL:= \
	http://launchpad.net/gcc-linaro/$(shell echo $(PKG_VERSION) | cut -d- -f1)/$(PKG_VERSION)/+download
  PKG_BUILD_DIR:=$(BUILD_DIR)/gcc-linaro-$(PKG_VERSION)
else
  GCC_VERSION:=$(shell $(TARGET_CC) -v 2>&1 | sed -ne 's/^gcc version \([^[:space:]]\+\) .*/\1/p')
  PKG_VERSION:=$(GCC_VERSION)
  PKG_SOURCE:=gcc-$(PKG_VERSION).tar.bz2
  PKG_SOURCE_URL:= \
	ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-$(PKG_VERSION) \
	http://mirrors.rcn.net/pub/sourceware/gcc/releases/gcc-$(PKG_VERSION) \
	ftp://ftp.gnu.org/gnu/gcc/releases/gcc-$(PKG_VERSION)
endif

PKG_RELEASE:=1
PKG_INSTALL:=1
PKG_FIXUP:=libtool

#PATCH_DIR=$(TOPDIR)/toolchain/gcc/patches/$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

SEP:=,
TARGET_LANGUAGES:="c$(if $(CONFIG_INSTALL_LIBSTDCPP),$(SEP)c++)$(if $(CONFIG_INSTALL_LIBGCJ),$(SEP)java)"
EXTRA_TARGET=$(if $(CONFIG_EXTRA_TARGET_ARCH),--enable-biarch --enable-targets=$(call qstrip,$(CONFIG_EXTRA_TARGET_ARCH_NAME))-linux-uclibc)

STRIP:=$(STAGING_DIR_HOST)/bin/sstrip
RSTRIP:= \
	NM="$(TARGET_CROSS)nm" \
	STRIP="$(STRIP) --strip-debug" \
	STRIP_KMOD="$(TARGET_CROSS)strip --strip-debug" \
	$(SCRIPT_DIR)/rstrip.sh

define Package/gcc-native
  SECTION:=devel
  CATEGORY:=Development
  TITLE:=gcc-native
  DEPENDS:=+mpfr +binutils +libmpc +libc +libgcc +zlib +libpthread  +libelf +libelf1
endef

define Package/gcc-native/description
	build a native toolchain for compiling on target
endef

CONFIGURE_VARS += \
	ac_cv_header_fenv_h=yes \


define Build/Prepare
	$(call Build/Prepare/Default)
#	($(CP) ./patches $(PKG_BUILD_DIR); cd $(PKG_BUILD_DIR); patch -Np1 < ./patches/001-cache-amnesia.patch;);
	(cd $(PKG_BUILD_DIR)/libstdc++-v3; \
	$(SED) 's/m4_rename(/m4_rename_force(/' acinclude.m4;);
endef

define Build/Configure
	$(SED) 's,gcc_no_link=yes,gcc_no_link=no,' $(PKG_BUILD_DIR)/libstdc++-v3/configure
	$(SED) 's/\"CFLAGS=/\"CFLAGS=$(FPIC) /' $(PKG_BUILD_DIR)/libstdc++-v3/Makefile.am
	(cd $(PKG_BUILD_DIR); rm -f config.cache; \
		SHELL="$(BASH)" \
		$(TARGET_CONFIGURE_OPTS) \
		$(PKG_BUILD_DIR)/configure \
			$(TARGET_CONFIGURE_ARGS) \
			--build=$(GNU_HOST_NAME) \
			--host=$(REAL_GNU_TARGET_NAME) \
			--target=$(REAL_GNU_TARGET_NAME) \
			--enable-languages=$(TARGET_LANGUAGES) \
			--enable-shared \
			--disable-__cxa_atexit \
			--enable-target-optspace \
			--with-gnu-ld \
			--disable-nls \
			--disable-libmudflap \
			--with-gmp=$(STAGING_DIR)/usr \
			--with-mpc=$(STAGING_DIR)/usr \
			--with-mpfr=$(STAGING_DIR)/usr \
			--with-libelf=$(STAGING_DIR)/usr \
			--disable-multilib \
			--prefix=/usr \
			$(EXTRA_TARGET) \
			$(SOFT_FLOAT_CONFIG_OPTION) \
			$(call qstrip,$(CONFIG_EXTRA_GCC_CONFIG_OPTIONS)) \
	);
endef

define Build/Compile
	export SHELL="$(BASH)"; $(MAKE_VARS) $(MAKE) -C $(PKG_BUILD_DIR) \
			DESTDIR="$(PKG_INSTALL_DIR)" $(MAKE_ARGS) all install
endef

define Package/gcc-native/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/lib/$(PKG_NAME)/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
	cp -ar $(PKG_INSTALL_DIR)/usr/{include,libexec} $(1)/usr
	#cp -a $(PKG_INSTALL_DIR)/usr/bin/{$(REAL_GNU_TARGET_NAME)-{g++,gcc},gccbug,cpp,gcov} $(1)/usr/bin
	cp -a $(PKG_INSTALL_DIR)/usr/bin/{$(REAL_GNU_TARGET_NAME)-{g++,gcc},cpp,gcov} $(1)/usr/bin
	ln -s $(REAL_GNU_TARGET_NAME)-g++ $(1)/usr/bin/c++
	ln -s $(REAL_GNU_TARGET_NAME)-g++ $(1)/usr/bin/g++
	ln -s $(REAL_GNU_TARGET_NAME)-g++ $(1)/usr/bin/$(REAL_GNU_TARGET_NAME)-c++
	ln -s $(REAL_GNU_TARGET_NAME)-gcc $(1)/usr/bin/gcc
	ln -s $(REAL_GNU_TARGET_NAME)-gcc $(1)/usr/bin/$(REAL_GNU_TARGET_NAME)-gcc-$(GCC_VERSION)
	cp -a $(PKG_INSTALL_DIR)/usr/lib/*.a $(1)/usr/lib/$(PKG_NAME)/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
	cp -ar $(PKG_INSTALL_DIR)/usr/lib/gcc $(1)/usr/lib
	cp -ar $(TOOLCHAIN_DIR)/include $(1)/usr/lib/$(PKG_NAME)/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
	cp -a $(TOOLCHAIN_DIR)/lib/*.{a,o,so*} $(1)/usr/lib/$(PKG_NAME)/$(REAL_GNU_TARGET_NAME)/$(GCC_VERSION)
endef

$(eval $(call BuildPackage,gcc-native))
