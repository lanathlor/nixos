{ pkgs, lib, ... }:
{
  import = [
    ./waybar/waybar.nix
  ];
  services.dunst = {
    base16_low = {
      frame_color = "#5e81ac77";
      msg_urgency = "low";
      background = "#3b4252";
      foreground = "#e5e9f0";
    };

    base16_normal = {
      frame_color = "#a3be8c77";
      msg_urgency = "normal";
      background = "#3b4252";
      foreground = "#e5e9f0";
    };

    base16_critical = {
      frame_color = "#bf616a77";
      msg_urgency = "critical";
      background = "#3b4252";
      foreground = "#e5e9f0";
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  programs.rofi = {
    theme = ./nord.rasi;
  };

  programs.kitty = {
    theme = lib.mkDefault "Nord";
  };

  programs.swaylock = {
    settings = lib.mkDefault {
      ignore-empty-password = true;
      show-failed-attempt = true;
      show-keyboard-layout = true;
      line-uses-ring = true;
      color = "2e3440";
      bs-hl-color = "b48eadff";
      caps-lock-bs-hl-color = "d08770ff";
      caps-lock-key-hl-color = "ebcb8bff";
      indicator-radius = "100";
      indicator-thickness = "10";
      inside-color = "2e3440ff";
      inside-clear-color = "81a1c1ff";
      inside-ver-color = "5e81acff";
      inside-wrong-color = "bf616aff";
      key-hl-color = "a3be8cff";
      layout-bg-color = "2e3440ff";
      ring-color = "3b4252ff";
      ring-clear-color = "88c0d0ff";
      ring-ver-color = "81a1c1ff";
      ring-wrong-color = "d08770ff";
      separator-color = "3b4252ff";
      text-color = "eceff4ff";
      text-clear-color = "3b4252ff";
      text-ver-color = "3b4252ff";
      text-wrong-color = "3b4252ff";
    };
  };

  home.file.".wallpapers/wallpaper.png" = {
    source = ./nord-city.jpeg;
  };
}
