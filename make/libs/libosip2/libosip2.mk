$(call PKG_INIT_LIB, 3.5.0)
$(PKG)_LIB_VERSION:=6.2.0
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=7691546f6b3349d10007fc1aaff0f4e0
$(PKG)_SITE:=@GNU/osip

$(PKG)_BINARY:=$($(PKG)_DIR)/src/osip2/.libs/libosip2.so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(STAGING_DIR)/usr/lib/libosip2.so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/libosip2.so.$($(PKG)_LIB_VERSION)

$(PKG)_PARSER_BINARY:=$($(PKG)_DIR)/src/osipparser2/.libs/libosipparser2.so.$($(PKG)_LIB_VERSION)
$(PKG)_PARSER_STAGING_BINARY:=$(STAGING_DIR)/usr/lib/libosipparser2.so.$($(PKG)_LIB_VERSION)
$(PKG)_PARSER_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/libosipparser2.so.$($(PKG)_LIB_VERSION)

$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static
$(PKG)_CONFIGURE_OPTIONS += --disable-debug
$(PKG)_CONFIGURE_OPTIONS += --disable-trace
$(PKG)_CONFIGURE_OPTIONS += --enable-pthread
$(PKG)_CONFIGURE_OPTIONS += --enable-semaphore

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY) $($(PKG)_PARSER_BINARY): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(LIBOSIP2_DIR) \
	all

$($(PKG)_STAGING_BINARY) $($(PKG)_PARSER_STAGING_BINARY): $($(PKG)_BINARY) $($(PKG)_PARSER_BINARY)
	$(PKG_MAKE) -C $(LIBOSIP2_DIR) \
		DESTDIR="$(STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(STAGING_DIR)/usr/lib/libosip*.la \
		$(STAGING_DIR)/usr/lib/pkgconfig/libosip*.pc

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$($(PKG)_PARSER_TARGET_BINARY): $($(PKG)_PARSER_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY) $($(PKG)_PARSER_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_PARSER_TARGET_BINARY)

$(pkg)-clean:
	-$(PKG_MAKE) -C $(LIBOSIP2_DIR) clean
	$(RM) -r \
		$(STAGING_DIR)/usr/lib/libosip* \
		$(STAGING_DIR)/usr/lib/pkgconfig/libosip*.pc \
		$(STAGING_DIR)/usr/include/osip* \
		$(STAGING_DIR)/usr/share/man/man?/osip*
	$(RM) $(LIBOSIP2_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(LIBOSIP2_TARGET_DIR)/libosip*.so*

$(PKG_FINISH)
