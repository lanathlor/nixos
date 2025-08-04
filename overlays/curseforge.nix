final: prev: {
  curseforge = final.stdenv.mkDerivation {
    pname = "curseforge";
    version = "1.0.0";

    src = final.fetchurl {
      url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
      sha256 = "1vsprxqswl6d0bsqj93xnn913y2k9h78dmxbzk766y7sidvl9q3h";
    };

    nativeBuildInputs = with final; [
      unzip
      makeWrapper
    ];

    buildInputs = with final; [
      # Core system libraries
      glibc
      gcc-unwrapped.lib

      # GUI libraries
      gtk3
      glib
      cairo
      pango
      gdk-pixbuf
      atk

      # X11 and graphics
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXtst
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXrandr
      xorg.libXScrnSaver
      xorg.libXi
      xorg.libXcursor
      mesa

      # Audio
      alsa-lib
      pulseaudio

      # Networking and crypto
      openssl
      curl
      cacert

      # Font and text rendering
      fontconfig
      freetype
      expat

      # Other essentials
      libdrm
      nspr
      nss
      at-spi2-atk
      libxkbcommon
      dbus
      systemd
    ];

    # Skip all the build phases that might corrupt the AppImage
    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    unpackPhase = ''
      runHook preUnpack
      unzip $src
      runHook postUnpack
    '';

    installPhase = ''
            runHook preInstall

            mkdir -p $out/bin $out/share/applications $out/share/pixmaps

            # Find and install the AppImage without any modifications
            APPIMAGE_FILE=$(find . -name "*.AppImage" -type f | head -1)
            if [ -z "$APPIMAGE_FILE" ]; then
              echo "Error: No AppImage file found in extracted archive"
              exit 1
            fi

            # Copy without any modifications to preserve AppImage magic bytes
            install -m755 "$APPIMAGE_FILE" $out/bin/curseforge.AppImage

            # Create wrapper script that uses appimage-run with proper environment
            makeWrapper ${final.appimage-run}/bin/appimage-run $out/bin/curseforge \
              --add-flags "$out/bin/curseforge.AppImage" \
              --prefix LD_LIBRARY_PATH : "${final.lib.makeLibraryPath (with final; [
                glibc gcc-unwrapped.lib gtk3 glib cairo pango gdk-pixbuf atk
                xorg.libX11 xorg.libXext xorg.libXrender xorg.libXtst xorg.libXcomposite
                xorg.libXdamage xorg.libXfixes xorg.libXrandr xorg.libXScrnSaver
                xorg.libXi xorg.libXcursor mesa alsa-lib pulseaudio openssl curl
                fontconfig freetype expat libdrm nspr nss at-spi2-atk libxkbcommon
                dbus systemd
              ])}" \
              --set APPIMAGE_EXTRACT_AND_RUN 1 \
              --set QT_XKB_CONFIG_ROOT "${final.xkeyboard_config}/share/X11/xkb" \
              --set FONTCONFIG_FILE "${final.fontconfig.out}/etc/fonts/fonts.conf" \
              --set SSL_CERT_FILE "${final.cacert}/etc/ssl/certs/ca-bundle.crt" \
              --prefix PATH : "${final.lib.makeBinPath [ final.coreutils final.which ]}"

            # Create desktop entry
            cat > $out/share/applications/curseforge.desktop << EOF
      [Desktop Entry]
      Type=Application
      Name=CurseForge
      Comment=Manage your addons, CC and mods
      Exec=$out/bin/curseforge
      Icon=curseforge
      Categories=Game;
      StartupNotify=true
      StartupWMClass=CurseForge
      EOF

            # Create a simple icon (placeholder)
            cat > $out/share/pixmaps/curseforge.svg << EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <svg width="48" height="48" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
        <rect width="48" height="48" rx="8" fill="#f16436"/>
        <text x="24" y="30" text-anchor="middle" fill="white" font-family="Arial" font-size="14" font-weight="bold">CF</text>
      </svg>
      EOF

            runHook postInstall
    '';

    meta = with final.lib; {
      description = "Manage your addons, CC and mods with the CurseForge app";
      homepage = "https://www.curseforge.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
      maintainers = [ ];
    };
  };
}
