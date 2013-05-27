$(call PKG_INIT_LIB, 6.2)
$(PKG)_LIB_VERSION:=$($(PKG)_VERSION)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=67948acb2ca081f23359d0256e9a271c
$(PKG)_SITE:=@GNU/$(pkg)

$(PKG)_$(PKG)_BINARY:=$($(PKG)_DIR)/shlib/libreadline.so.$($(PKG)_LIB_VERSION)
$(PKG)_HISTORY_BINARY:=$($(PKG)_DIR)/shlib/libhistory.so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_$(PKG)_BINARY:=$(STAGING_DIR)/usr/lib/libreadline.so.$($(PKG)_LIB_VERSION)
$(PKG)_STAGING_HISTORY_BINARY:=$(STAGING_DIR)/usr/lib/libhistory.so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_$(PKG)_BINARY:=$($(PKG)_TARGET_DIR)/libreadline.so.$($(PKG)_LIB_VERSION)
$(PKG)_TARGET_HISTORY_BINARY:=$($(PKG)_TARGET_DIR)/libhistory.so.$($(PKG)_LIB_VERSION)

$(PKG)_DEPENDS_ON := ncurses

$(PKG)_CONFIGURE_ENV += bash_cv_func_ctype_nonascii=no
$(PKG)_CONFIGURE_ENV += bash_cv_func_sigsetjmp=present
$(PKG)_CONFIGURE_ENV += bash_cv_func_strcoll_broken=no
$(PKG)_CONFIGURE_ENV += bash_cv_must_reinstall_sighandlers=no
$(PKG)_CONFIGURE_ENV += bash_cv_termcap_lib=libncurses

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_READLINE_BINARY) $($(PKG)_HISTORY_BINARY): $($(PKG)_DIR)/.configured
	$(PKG_MAKE) -C $(READLINE_DIR)

$($(PKG)_STAGING_READLINE_BINARY) $($(PKG)_STAGING_HISTORY_BINARY): $($(PKG)_READLINE_BINARY) $($(PKG)_HISTORY_BINARY)
	$(PKG_MAKE) -C $(READLINE_DIR) \
		DESTDIR="$(STAGING_DIR)" \
		install

$($(PKG)_TARGET_READLINE_BINARY): $($(PKG)_STAGING_READLINE_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$($(PKG)_TARGET_HISTORY_BINARY): $($(PKG)_STAGING_HISTORY_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg): $($(PKG)_STAGING_READLINE_BINARY) $($(PKG)_STAGING_HISTORY_BINARY)

$(pkg)-precompiled: $($(PKG)_TARGET_READLINE_BINARY) $($(PKG)_TARGET_HISTORY_BINARY)

$(pkg)-clean:
	$(RM) -r \
		$(STAGING_DIR)/usr/lib/libreadline* \
		$(STAGING_DIR)/usr/lib/libhistory* \
		$(STAGING_DIR)/usr/include/readline
	-$(PKG_MAKE) -C $(READLINE_DIR) clean

$(pkg)-uninstall:
	$(RM) $(READLINE_TARGET_DIR)/libreadline*.so*
	$(RM) $(READLINE_TARGET_DIR)/libhistory*.so*

$(PKG_FINISH)
