final: prev: {
  wago-addons = prev.stdenv.mkDerivation rec {
    pname = "wago-addons";
    version = "2.6.4";

    src = prev.fetchurl {
      url = "https://wago-addons.ams3.digitaloceanspaces.com/wagoapp/WagoApp_${version}.AppImage";
      sha256 = "sha256-lQWMujwMp9ng/wkdjLrR5QSTTZqnJFna9RBwU17kc68=";
    };

    # Don't strip or patch ELF to preserve AppImage magic bytes
    dontStrip = true;
    dontPatchELF = true;
    dontBuild = true;
    dontConfigure = true;

    nativeBuildInputs = with prev; [
      appimage-run
      makeWrapper
    ];

    unpackPhase = "true"; # Skip unpacking since we're keeping the AppImage

    installPhase = ''
            runHook preInstall

            mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/256x256/apps

            # Copy the AppImage to the output
            cp $src $out/bin/wago-addons.appimage
            chmod +x $out/bin/wago-addons.appimage

            # Create wrapper script for clean launch
            makeWrapper ${prev.appimage-run}/bin/appimage-run $out/bin/wago-addons \
              --add-flags "$out/bin/wago-addons.appimage" \
              --prefix LD_LIBRARY_PATH : "${prev.lib.makeLibraryPath [
                prev.stdenv.cc.cc.lib
                prev.zlib
                prev.openssl
                prev.curl
                prev.glib
                prev.gtk3
                prev.cairo
                prev.pango
                prev.gdk-pixbuf
                prev.atk
                prev.at-spi2-atk
                prev.libdrm
                prev.xorg.libxcb
                prev.xorg.libX11
                prev.xorg.libXcomposite
                prev.xorg.libXdamage
                prev.xorg.libXext
                prev.xorg.libXfixes
                prev.xorg.libXrandr
                prev.xorg.libXrender
                prev.xorg.libXScrnSaver
                prev.xorg.libXtst
                prev.xorg.libxshmfence
                prev.libxkbcommon
                prev.libGL
                prev.mesa
                prev.nss
                prev.nspr
                prev.systemd
                prev.libnotify
                prev.libuuid
                prev.dbus
                prev.expat
                prev.pcre
                prev.util-linux
                prev.xorg.libXi
                prev.xorg.libXcursor
                prev.xorg.libXdamage
                prev.xorg.libXinerama
                prev.fontconfig
                prev.freetype
                prev.xorg.libXft
                prev.xorg.libXmu
                prev.libogg
                prev.libvorbis
                prev.flac
                prev.libopus
                prev.libjpeg
                prev.libpng
                prev.libtiff
                prev.giflib
                prev.librsvg
                prev.pixman
                prev.harfbuzz
                prev.icu
                prev.graphite2
                prev.fribidi
                prev.udev
                prev.libinput
                prev.wayland
                prev.libffi
                prev.libxml2
                prev.libxslt
                prev.sqlite
                prev.xorg.libXaw
                prev.xorg.libXpm
                prev.bzip2
                prev.brotli
                prev.zstd
                prev.lz4
                prev.xz
              ]}" \
              --set-default FONTCONFIG_FILE "${prev.fontconfig.out}/etc/fonts/fonts.conf" \
              --set-default FONTCONFIG_PATH "${prev.fontconfig.out}/etc/fonts" \
              --prefix PATH : "${prev.lib.makeBinPath [prev.xdg-utils]}"

            # Create desktop entry
            cat > $out/share/applications/wago-addons.desktop << EOF
      [Desktop Entry]
      Type=Application
      Name=Wago Addons
      Comment=World of Warcraft addon manager
      Exec=$out/bin/wago-addons
      Icon=wago-addons
      Categories=Game;
      StartupWMClass=wago-addons
      EOF

            # Extract and install icon
            ${prev.appimage-run}/bin/appimage-run --appimage-extract-and-run $out/bin/wago-addons.appimage --help > /dev/null 2>&1 || true

            # Try to find icon in extracted files or create a simple fallback
            if [ -d squashfs-root ]; then
              find squashfs-root -name "*.png" -size +1000c | head -1 | xargs -r cp -t $out/share/icons/hicolor/256x256/apps/ 2>/dev/null || true
              if [ -f $out/share/icons/hicolor/256x256/apps/*.png ]; then
                mv $out/share/icons/hicolor/256x256/apps/*.png $out/share/icons/hicolor/256x256/apps/wago-addons.png
              fi
              rm -rf squashfs-root
            fi

            # Create a simple fallback icon if extraction failed
            if [ ! -f $out/share/icons/hicolor/256x256/apps/wago-addons.png ]; then
              # Create a simple colored rectangle as fallback
              echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==" | base64 -d > $out/share/icons/hicolor/256x256/apps/wago-addons.png
            fi

            runHook postInstall
    '';

    meta = with prev.lib; {
      description = "World of Warcraft addon manager by Wago";
      homepage = "https://addons.wago.io/";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = [ ];
    };
  };
}
