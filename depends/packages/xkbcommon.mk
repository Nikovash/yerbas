package=xkbcommon
$(package)_version=1.7.0
$(package)_download_path=https://xkbcommon.org/download
$(package)_file_name=libxkbcommon-$($(package)_version).tar.xz
$(package)_sha256_hash=65782f0a10a4b455af9c6baab7040e2f537520caa2ec2092805cdfd36863b247
$(package)_dependencies=native_meson native_ninja native_bison

define $(package)_config_cmds
  env -u PKG_CONFIG_LIBDIR -u PKG_CONFIG_PATH CC="$(host_CC)" \
    $(build_prefix)/bin/meson setup build --prefix="$(host_prefix)" --libdir=lib --buildtype=release \
      --default-library=static -Db_staticpic=true -Denable-x11=true \
      -Denable-tools=false -Denable-wayland=false -Denable-xkbregistry=false \
      -Denable-bash-completion=false -Dxkb-config-root=/usr/share/X11/xkb \
      -Dx-locale-root=/usr/share/X11/locale
endef

define $(package)_build_cmds
  $(build_prefix)/bin/meson compile -C build -j 2
endef

define $(package)_stage_cmds
  DESTDIR=$($(package)_staging_dir) $(build_prefix)/bin/meson install -C build --no-rebuild && \
  mkdir -p $($(package)_staging_prefix_dir)/share/licenses/xkbcommon && \
  cp LICENSE $($(package)_staging_prefix_dir)/share/licenses/xkbcommon/
endef
