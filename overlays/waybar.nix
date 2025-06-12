final: prev: {
  weatherScript = final.stdenv.mkDerivation rec {
    pname = "weather";
    version = "0.1";
    src = ./weather.sh;

    nativeBuildInputs = [ final.makeWrapper ];
    buildInputs = with final; [ coreutils jq curl ];

    unpackCmd = ''
      mkdir weather
      cp $curSrc weather/weather.sh
    '';

    installPhase = ''
      install -Dm755 weather.sh $out/bin/weather.sh
      wrapProgram $out/bin/weather.sh --prefix PATH : '${final.lib.strings.makeBinPath buildInputs}'
    '';
  };

  rofi-override = prev.rofi-wayland.override {
    plugins = [ prev.rofi-power-menu ];
  };

  rofi-with-power-menu = final.stdenv.mkDerivation rec {
    pname = "rofi-with-power-menu";
    version = "0.1";
    src = final.writeShellScript "rofi-with-power-menu.sh" ''
      rofi -show p -modi p:"rofi-power-menu"
    '';

    nativeBuildInputs = [ final.makeWrapper ];
    buildInputs = [ final.rofi-override final.rofi-power-menu final.util-linux ];

    unpackCmd = ''
      mkdir rofi-with-power-menu
      cp $curSrc rofi-with-power-menu/rofi-with-power-menu.sh
    '';

    installPhase = ''
      install -Dm755 rofi-with-power-menu.sh $out/bin/rofi-with-power-menu.sh
      wrapProgram $out/bin/rofi-with-power-menu.sh --prefix PATH : '${final.lib.strings.makeBinPath buildInputs}'
    '';
  };
}
