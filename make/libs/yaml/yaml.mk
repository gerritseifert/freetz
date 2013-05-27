$(call PKG_INIT_LIB, 0.1.4)
$(PKG)_LIB_VERSION:=2.0.2
$(PKG)_SOURCE:=yaml-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=36c852831d02cf90508c29852361d01b
$(PKG)_SITE:=http://pyyaml.org/download/libyaml/

$(PKG)_BINARY:=$($(PKG)_DIR)/libyaml-0.so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_BINARY:=$(STAGING_DIR)/lib/libyaml-0.so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/libyaml-0.so.$($(PKG)_LIB_VERSION)

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(YAML_DIR)

$($(PKG)_STAGING_BINARY): $($(PKG)_BINARY)
	$(PKG_MAKE) -C $(YAML_DIR) \
		DESTDIR="$(STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(STAGING_DIR)/usr/lib/libyaml.a

$($(PKG)_TARGET_BINARY): $($(PKG)_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(PKG_MAKE) -C $(YAML_DIR) clean
	$(RM) $(STAGING_DIR)/usr/lib/libyaml*.* \
		$(STAGING_DIR)/include/yaml.h \
		$(STAGING_DIR)/include/pkgconfig\yaml*.pc

$(pkg)-uninstall:
	$(RM) $(YAML_TARGET_DIR)/libyaml*.so*

$(PKG_FINISH)
