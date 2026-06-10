{ pkgs, lib, config, ... }:
{

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     weatherScript = pkgs.stdenv.mkDerivation rec {
  #       name = "weather";
  #       version = "0.1";
  #       src = ./weather.sh;
  #       nativeBuildInputs = [ pkgs.makeWrapper ];
  #       buildInputs = with pkgs; [ coreutils jq curl ];
  #       unpackCmd = ''
  #         mkdir weather

  #         cp $curSrc weather/weather.sh
  #       '';
  #       installPhase = ''
  #         install -Dm755 weather.sh $out/bin/weather.sh

  #         wrapProgram $out/bin/weather.sh --prefix PATH : '${lib.strings.makeBinPath buildInputs}'
  #       '';
  #     };
  #   })

  #   (final: prev: {
  #     rofi-override = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-power-menu ]; };
  #     rofi-with-power-menu = pkgs.stdenv.mkDerivation rec {
  #       name = "rofi-with-power-menu";
  #       nativeBuildInputs = [ pkgs.makeWrapper ];
  #       buildInputs = with pkgs; [ final.rofi-override rofi-power-menu util-linux ];
  #       version = "0.1";
  #       src = pkgs.writeShellScript "rofi-with-power-menu.sh" ''rofi -show p -modi p:"rofi-power-menu"'';
  #       unpackCmd = ''
  #         mkdir rofi-with-power-menu
  #         cp $curSrc rofi-with-power-menu/rofi-with-power-menu.sh
  #       '';
  #       installPhase = ''
  #         install -Dm755 rofi-with-power-menu.sh $out/bin/rofi-with-power-menu.sh

  #         wrapProgram $out/bin/rofi-with-power-menu.sh --prefix PATH : '${lib.strings.makeBinPath buildInputs}'
  #       '';
  #     };
  #   })
  # ];

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = {
      topBar = {
        layer = "top";
        position = "top";
        height = 30;
        margin-top = 6;
        margin-left = 8;
        margin-right = 8;
        modules-left = [ "clock" "idle_inhibitor" "custom/theme-switch" "custom/media" ];
        modules-center = [ "mpris" ];
        modules-right = [ "cpu" "memory" "temperature" "disk" "disk#data" ];
        mpris = {
          format = "{player_icon} {dynamic}";
          format-paused = "Paused: {status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {
            paused = "⏸";
          };
          ignored-players = [ "firefox" ];
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };
        "custom/theme-switch" = {
          exec = "cat $HOME/.cache/current-theme 2>/dev/null || echo Nord";
          interval = "once";
          format = "󰏘  {}";
          on-click = "theme-switch";
          tooltip = false;
        };
        clock = {
          format = " {:%H:%M   %e %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          today-format = "<b>{}</b>";
          on-click = "${pkgs.xfce.orage}/bin/orage";
        };
        cpu = {
          interval = "1";
          format = " {max_frequency}GHz <span color=\"darkgray\">| {usage}%</span>";
          on-click = "${pkgs.kitty}/bin/kitty -e btop";
          tooltip = false;
        };
        memory = {
          format = " {used}Go<span color=\"darkgray\">/{total}Go</span>";
          on-click = "${pkgs.kitty}/bin/kitty -e btop";
          tooltip = false;
        };
        disk = {
          interval = 30;
          format = " {used}<span color=\"darkgray\">/{total}Go</span>";
          path = "/";
          on-click = "${pkgs.xfce.thunar}/bin/thunar ${config.home.homeDirectory}";
          on-right-click = "${pkgs.baobab}/bin/baobab /";
        };
        "disk#data" = {
          interval = 30;
          format = " {used}<span color=\"darkgray\">/{total}Go</span>";
          path = "${config.home.homeDirectory}/data";
          on-click = "${pkgs.xfce.thunar}/bin/thunar ${config.home.homeDirectory}/data";
          on-right-click = "${pkgs.baobab}/bin/baobab ${config.home.homeDirectory}/data";
        };
        temperature = {
          interval = "4";
          critical-threshold = 74;
          format-critical = " {temperatureC}°C";
          format = "{icon} {temperatureC}°C";
          format-icons = [ "" "" "" ];
          max-length = 7;
          min-length = 7;
        };
      };
      bottomBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        margin-bottom = 6;
        margin-left = 8;
        margin-right = 8;
        modules-left = [ "custom/powermenu" "custom/weather" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "bluetooth" "pulseaudio" "network" "tray" ];
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "1" = "<span color=\"#D8DEE9\"></span>";
            "2" = "<span color=\"#ff9500\"></span>";
            "3" = "<span color=\"#007acc\"></span>";
            "4" = "<span color=\"#ff9500\"></span>";
            "5" = "<span color=\"#66c0f4\"></span>";
            "6" = "<span color=\"#D8DEE9\">6</span>";
            "7" = "<span color=\"#D8DEE9\">7</span>";
            "8" = "<span color=\"#D8DEE9\">8</span>";
            "9" = "<span color=\"#2573ae\"></span>";
            "10" = "<span color=\"#7289DA\"></span>";
            urgent = "";
            focused = "";
            default = "";
          };
        };
        tray = {
          icon-size = 10;
          spacing = 4;
        };
        pulseaudio = {
          scroll-step = 3;
          max-volume = 200;
          format = "{icon} {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-click-right = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "" "" ];
          on-scroll-up = "light -A 3";
          on-scroll-down = "light -U 3";
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-good = "{icon} {capacity}%";
          format-full = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        network = {
          format-wifi = " {essid}";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "";
          format-alt = "{ifname}: {ipaddr}/{cidr}  {bandwidthDownBits}  {bandwidthUpBits}";
          family = "ipv4";
          tooltip-format-wifi = " {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\n {bandwidthDownBits}  {bandwidthUpBits}";
          tooltip-format-ethernet = " {ifname}\nIP: {ipaddr}\n {bandwidthDownBits}  {bandwidthUpBits}";
        };
        bluetooth = {
          interval = 30;
          format = "{icon}";
          format-connected-battery = "{icon} {status}: {device_alias} |  {device_battery_percentage}";
          format-connected = "{icon} {status}: {device_alias}";
          format-icons = {
            enabled = "";
            disabled = "";
          };
          on-click = "${pkgs.blueman}/bin/blueman-manager";
        };
        "custom/weather" = {
          exec = "${pkgs.weatherScript}/bin/weather.sh";
          format = "{}";
        };
        "custom/powermenu" = {
          format = "";
          on-click = "${pkgs.rofi-with-power-menu}/bin/rofi-with-power-menu.sh";
        };
      };
    };
    systemd = {
      enable = true;
      target = "basic.target";
    };
    # style is managed by theme-switch (symlinked to current theme's CSS)
  };
}
