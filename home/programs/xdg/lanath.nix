{ pkgs, stamusctl, ... }:
{
  xdg.enable = true;

  xdg.userDirs.enable = true;
  xdg.mimeApps.enable = true;

  xdg.configFile."fish/completions/stamusctl.fish".text = ''
    ${stamusctl.packages.${pkgs.system}.default}/bin/stamusctl completion fish
  '';

  home.file."Documents/.keep".source = builtins.toFile "keep" "";
  home.file."Downloads/.keep".source = builtins.toFile "keep" "";
  home.file."Music/.keep".source = builtins.toFile "keep" "";
  home.file."Work/.keep".source = builtins.toFile "keep" "";
  # home.file."Dotfiles".source = builtins.fetchGit {
  #   url = "https://github.com/lanathlor/nixos";
  # };
  xdg.mimeApps = {
    associations.added = {
      "text/plain" = [ "code.desktop" ];
    };
    defaultApplications = {
      "application/pdf" = [ "zen.desktop" ];
      "application/javascript" = [ "code.desktop" ];
      "text/plain" = [ "code.desktop" ];
      "text/*" = [ "code.desktop" ];
      "text/html" = [ "code.desktop" ];
      "text/xml" = [ "code.desktop" ];
      "text/javascript" = [ "code.desktop" ];
      "text/json" = [ "code.desktop" ];
      "text/x-csrc" = [ "code.desktop" ]; # ts files
      "image/gif" = [ "zen.desktop" ];
      "image/jpeg" = [ "zen.desktop" ];
      "image/png" = [ "zen.desktop" ];
      "image/webp" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/about" = [ "zen.desktop" ];
      "x-scheme-handler/unknown" = [ "zen.desktop" ];
      "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      "x-scheme-handler/sms" = [ "thunderbird.desktop" ];
      "x-scheme-handler/mms" = [ "thunderbird.desktop" ];
      "x-scheme-handler/chrome" = [ "thunderbird.desktop" ];
      "x-scheme-handler/spotify" = [ "spotify.desktop" ];
      "x-scheme-handler/steam" = [ "steam.desktop" ];
    };
  };
}
