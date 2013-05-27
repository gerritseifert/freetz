$(call PKG_INIT_LIB, 1.6.1)
$(PKG)_LIB_VERSION:=0.2.7
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.bz2
$(PKG)_SOURCE_MD5:=748554a18e1771913f4f402ee9f957c9
$(PKG)_SITE:=http://verplant.org/liboping/files

$(PKG)_BINARY:=$($(PKG)_DIR)/src/.libs/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(STAGING_DIR)/usr/lib/$(pkg).so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$(pkg).so.$($(PKG)_LIB_VERSION)

$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_IPV6_SUPPORT

$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static
$(PKG)_CONFIGURE_OPTIONS += --with-perl-bindings=no

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(LIBOPING_DIR) all

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(PKG_MAKE) -C $(LIBOPING_DIR) \
		DESTDIR="$(STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(STAGING_DIR)/usr/lib/liboping.la

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(PKG_MAKE) -C $(LIBOPING_DIR) clean
	$(RM) \
		$(STAGING_DIR)/usr/lib/liboping* \
		$(STAGING_DIR)/usr/include/oping.h \
		$(STAGING_DIR)/usr/bin/{oping,noping} \
		$(STAGING_DIR)/usr/share/man/man?/*oping*

$(pkg)-uninstall:
	$(RM) $(LIBOPING_TARGET_DIR)/liboping*.so*

$(PKG_FINISH)
