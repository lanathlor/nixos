{ pkgs, zen-browser, ... }: {
  imports = [
    zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      OfferToSaveLogins = false;
    };
    profiles.default = {
      bookmarks = {
        force = true;
        settings = [
          {
            name = "NixOS - search";
            tags = [ "nixos" ];
            keyword = "nixos";
            url = "https://search.nixos.org/packages";
          }
          {
            name = "NixOS - home-manager options";
            tags = [ "nixos" ];
            keyword = "nixos";
            url = "https://nix-community.github.io/home-manager/options.xhtml";
          }
        ];
      };

      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          sponsorblock
          keepassxc-browser
          h264ify
          react-devtools
          reduxdevtools
          linkhints
          theme-nord-polar-night
        ];
      };

      search = {
        engines = {

          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "YouTube" = {
            urls = [{
              template = "https://www.youtube.com/results";
              params = [
                { name = "search_query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://www.youtube.com/s/desktop/92c9ad1f/img/favicon.ico"; # optional: static URL
            definedAliases = [ "@yt" ];
          };

          "GitHub" = {
            urls = [{
              template = "https://github.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://github.githubassets.com/favicons/favicon.svg"; # optional
            definedAliases = [ "@gh" ];
          };

          "GitLab (Stamus)" = {
            urls = [{
              template = "https://git.stamus-networks.com/search";
              params = [
                { name = "search"; value = "{searchTerms}"; }
              ];
            }];
            icon = "https://git.stamus-networks.com/assets/favicon.png"; # Replace with your favicon path if needed
            definedAliases = [ "@sgl" ];
          };

        };
      };
    };
  };
}
