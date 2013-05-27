$(call PKG_INIT_BIN,1.14)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=36e64bd6c7d0a299d5acd1109988099b
$(PKG)_SITE:=http://rutschle.net/tech
$(PKG)_BINARY:=$($(PKG)_DIR)/sslh-fork
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/sbin/sslh

$(PKG)_DEPENDS_ON += libconfig

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(SSLH_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -DLIBCONFIG" \
		USELIBWRAP= \
		sslh

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(PKG_MAKE) -C $(SSLH_DIR) clean
	$(RM) $(SSLH_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $(SSLH_TARGET_BINARY)

$(PKG_FINISH)
