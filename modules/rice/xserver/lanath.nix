{ ... }:
{
  xdg.userDirs.enable = true;
  xdg.mimeApps.enable = true;

  home.file."Document/.keep".source = builtins.toFile "keep" "";
  home.file."Downloads/.keep".source = builtins.toFile "keep" "";
  home.file."Music/.keep".source = builtins.toFile "keep" "";
  home.file."Work/.keep".source = builtins.toFile "keep" "";
  home.file."Dotfiles".source = builtins.fetchGit {
    url = "https://github.com/lanathlor/nixos";
  };
  xdg.mimeApps = {
    associations.added = {
      "text/plain" = [ "code.desktop" ];
    };
    defaultApplications = {
      "application/pdf" = [ "firefox.desktop" ];
      "application/javascript" = [ "code.desktop" ];
      "text/plain" = [ "code.desktop" ];
      "text/*" = [ "code.desktop" ];
      "text/html" = [ "code.desktop" ];
      "text/xml" = [ "code.desktop" ];
      "text/javascript" = [ "code.desktop" ];
      "text/json" = [ "code.desktop" ];
      "text/x-csrc" = [ "code.desktop" ]; # ts files
      "image/gif" = [ "firefox.desktop" ];
      "image/jpeg" = [ "firefox.desktop" ];
      "image/png" = [ "firefox.desktop" ];
      "image/webp" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "x-scheme-handler/sms" = [ "thunderbird.desktop" ];
      "x-scheme-handler/mms" = [ "thunderbird.desktop" ];
      "x-scheme-handler/chrome" = [ "thunderbird.desktop" ];
      "x-scheme-handler/spotify" = [ "spotify.desktop" ];
      "x-scheme-handler/steam" = [ "steam.desktop" ];
    };
  };
}
