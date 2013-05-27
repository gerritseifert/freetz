$(call PKG_INIT_LIB, 0.1.12)
$(PKG)_SHORT_VERSION:=0.1
$(PKG)_LIB_VERSION:=4.4.4
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=caf182cbc7565dac0fd72155919672e6
$(PKG)_SITE:=@SF/$(pkg)

$(PKG)_BINARY:=$($(PKG)_DIR)/.libs/$(pkg)-$($(PKG)_SHORT_VERSION).so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(STAGING_DIR)/usr/lib/$(pkg)-$($(PKG)_SHORT_VERSION).so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/$(pkg)-$($(PKG)_SHORT_VERSION).so.$($(PKG)_LIB_VERSION)

$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(LIBUSB_DIR) all

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(PKG_MAKE) -C $(LIBUSB_DIR) \
		DESTDIR="$(STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(STAGING_DIR)/usr/lib/libusb.la \
		$(STAGING_DIR)/usr/lib/pkgconfig/libusb.pc \
		$(STAGING_DIR)/usr/bin/libusb-config

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP_WILDCARD_BEFORE_SO)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(PKG_MAKE) -C $(LIBUSB_DIR) clean
	$(RM) \
		$(STAGING_DIR)/bin/libusb-config \
		$(STAGING_DIR)/includes/usb*.h \
		$(STAGING_DIR)/lib/libusb* \
		$(STAGING_DIR)/lib/pkgconfig/libusb.pc

$(pkg)-uninstall:
	$(RM) $(LIBUSB_TARGET_DIR)/libusb*.so*

$(PKG_FINISH)
