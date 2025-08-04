final: prev: {
  curseforge = final.stdenv.mkDerivation rec {
    pname = "curseforge";
    version = "1.0.0";

    src = final.fetchurl {
      url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
      sha256 = "1vsprxqswl6d0bsqj93xnn913y2k9h78dmxbzk766y7sidvl9q3h";
    };

    nativeBuildInputs = with final; [
      unzip
      makeWrapper
      appimage-run
    ];

    buildInputs = with final; [
      gtk3
      glib
      nss
      nspr
      atk
      at-spi2-atk
      libdrm
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXrandr
      mesa
      expat
      libxkbcommon
      xorg.libXfixes
      xorg.libXScrnSaver
      alsa-lib
    ];

    unpackPhase = ''
      runHook preUnpack
      unzip $src
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      
      mkdir -p $out/bin $out/share/applications $out/share/pixmaps
      
      # Install the AppImage
      cp *.AppImage $out/bin/curseforge.appimage
      chmod +x $out/bin/curseforge.appimage
      
      # Create wrapper script
      makeWrapper ${final.appimage-run}/bin/appimage-run $out/bin/curseforge \
        --add-flags "$out/bin/curseforge.appimage" \
        --prefix LD_LIBRARY_PATH : "${final.lib.makeLibraryPath buildInputs}"
      
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
