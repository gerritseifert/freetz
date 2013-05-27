$(call PKG_INIT_LIB, 1.15)
$(PKG)_LIB_VERSION:=0.0.0
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=c61ef795fa450eb692602a661ec8d7f1
$(PKG)_SITE:=http://rpm5.org/files/popt

$(PKG)_BINARY:=$($(PKG)_DIR)/.libs/libpopt.so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(STAGING_DIR)/usr/lib/libpopt.so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/libpopt.so.$($(PKG)_LIB_VERSION)

# touch configure.ac to prevent configure from being regenerated
$(PKG)_CONFIGURE_PRE_CMDS += touch -t 200001010000.00 ./configure.ac;

$(PKG)_CONFIGURE_ENV += ac_cv_va_copy=yes
$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static
$(PKG)_CONFIGURE_OPTIONS += --without-libintl-prefix
$(PKG)_CONFIGURE_OPTIONS += --without-libiconv-prefix

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(POPT_DIR)

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(PKG_MAKE) -C $(POPT_DIR) \
		DESTDIR="$(STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(STAGING_DIR)/usr/lib/libpopt.la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(PKG_MAKE) -C $(POPT_DIR) clean
	$(RM) $(STAGING_DIR)/usr/lib/libpopt.* \
		$(STAGING_DIR)/usr/include/popt.h

$(pkg)-uninstall:
	$(RM) $(POPT_TARGET_DIR)/libpopt*.so*

$(PKG_FINISH)
