{ pkgs, lib, ... }:
let
  # Nord fallback colors for the default CSS (before home-manager populates the mutable CSS)
  fallbackCss = ''
    window {
      background-color: rgba(46, 52, 64, 0.85);
    }

    entry {
      background-color: #3b4252;
      color: #d8dee9;
      border: 2px solid #3b4252;
      border-radius: 8px;
      padding: 8px 12px;
    }

    entry:focus {
      border-color: #5e81ac;
    }

    button {
      background-color: #3b4252;
      color: #d8dee9;
      border: none;
      border-radius: 8px;
      padding: 8px 16px;
    }

    button:hover {
      background-color: #5e81ac;
      color: #eceff4;
    }

    label {
      color: #d8dee9;
    }
  '';

  regreetWrapper = pkgs.writeShellScript "regreet-wrapper" ''
    if [ -f /var/lib/regreet-theme/regreet.css ]; then
      exec ${lib.getExe pkgs.regreet} --style /var/lib/regreet-theme/regreet.css
    else
      exec ${lib.getExe pkgs.regreet}
    fi
  '';
in
{
  programs.regreet = {
    enable = true;

    cageArgs = [ "-s" "-d" ];

    extraCss = fallbackCss;

    settings = {
      background = {
        path = "/var/lib/regreet-theme/wallpaper";
        fit = "Cover";
      };
      GTK.application_prefer_dark_theme = true;
    };

    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
      size = 14;
    };
  };

  # Override the default command to use a wrapper that picks up mutable CSS
  services.greetd.settings.default_session.command =
    "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} -s -d -- ${regreetWrapper}";

  # Mutable directory for theme-switch to write CSS and wallpaper into
  systemd.tmpfiles.rules = [
    "d /var/lib/regreet-theme 0775 root users -"
  ];
}
