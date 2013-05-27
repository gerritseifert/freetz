$(call PKG_INIT_BIN, 1.6.20070208)
$(PKG)_LIB_VERSION:=1.0.6
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=07f6cad7e03fd74a949588c3d4b333de
$(PKG)_SITE:=ftp://ftp.ossp.org/pkg/lib/js

$(PKG)_BINARY_BUILD_DIR:=$($(PKG)_DIR)/.libs/js
$(PKG)_BINARY_TARGET_DIR:=$($(PKG)_DEST_DIR)/usr/bin/js

$(PKG)_LIBNAME:=lib$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_LIBRARY_BUILD_DIR:=$($(PKG)_DIR)/.libs/$($(PKG)_LIBNAME)
$(PKG)_LIBRARY_STAGING_DIR:=$(STAGING_DIR)/usr/lib/$($(PKG)_LIBNAME)
$(PKG)_LIBRARY_TARGET_DIR:=$($(PKG)_TARGET_LIBDIR)/$($(PKG)_LIBNAME)

$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static
$(PKG)_CONFIGURE_OPTIONS += --with-dso
$(PKG)_CONFIGURE_OPTIONS += --without-editline
$(PKG)_CONFIGURE_OPTIONS += --without-file
$(PKG)_CONFIGURE_OPTIONS += --without-perl

$(PKG)_CONFIGURE_ENV += ac_cv_va_copy=C99

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY_BUILD_DIR) $($(PKG)_LIBRARY_BUILD_DIR): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(JS_DIR)

$($(PKG)_LIBRARY_STAGING_DIR): $($(PKG)_LIBRARY_BUILD_DIR)
	$(PKG_MAKE) -C $(JS_DIR) \
		DESTDIR="$(STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) $(STAGING_DIR)/usr/lib/libjs.la
	$(call PKG_FIX_LIBTOOL_LA,prefix) $(STAGING_DIR)/usr/lib/pkgconfig/js.pc
	$(call PKG_FIX_LIBTOOL_LA,prefix exec_prefix js_bindir js_libdir js_includedir js_mandir js_datadir js_acdir) $(STAGING_DIR)/usr/bin/js-config

$($(PKG)_BINARY_TARGET_DIR): $($(PKG)_BINARY_BUILD_DIR)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_LIBRARY_TARGET_DIR): $($(PKG)_LIBRARY_STAGING_DIR)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_LIBRARY_STAGING_DIR)

$(pkg)-precompiled: $($(PKG)_BINARY_TARGET_DIR) $($(PKG)_LIBRARY_TARGET_DIR)

$(pkg)-clean:
	-$(PKG_MAKE) -C $(JS_DIR) clean
	$(RM) -r \
		$(STAGING_DIR)/usr/lib/libjs.* \
		$(STAGING_DIR)/usr/lib/pkgconfig/js.pc \
		$(STAGING_DIR)/usr/bin/js-config \
		$(STAGING_DIR)/usr/include/js/

$(pkg)-uninstall:
	$(RM) $(JS_BINARY_TARGET_DIR)
	$(RM) $(JS_TARGET_LIBDIR)/libjs.so*

$(call PKG_ADD_LIB,libjs)
$(PKG_FINISH)
