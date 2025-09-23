{ ... }:
{
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
