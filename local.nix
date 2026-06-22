# local.nix — your personal overrides (only set what differs from config-defaults.nix)
# After editing, run: git update-index --skip-worktree local.nix
# This prevents accidentally committing your personal data.
#
# Setup checklist:
#   - Place your SSH public keys in keys/ (see keys.example/README.md)
#   - Copy .sops.example.yaml to .sops.yaml and set your age public key
#   - Generate hardware config: nixos-generate-config --show-hardware-config
{
  hostName = "desktop";
  githubUser = "lanathlor";
  githubRepo = "nixos";
  localDomain = "local.dosismart.com";

  extraHosts = {
    "2.13.105.165" = [ "master.monkey" "*.master.monkey" ];
  };

  # The OpenWeather API key lives in sops as `weather_appid`, not here.
  weather = {
    lat = "47.13";
    lon = "1.33";
  };

  agePublicKey = "age10cctlpt4x3rn5r0hdqzmg0wwnmepgu2j65cxl07mudmhtmt8k4ns50usjt";

  llm.enable = true;
  qemu.enable = true;
  vscodeServer.enable = true;
  wayvnc.enable = true;
  headless.enable = true;

  extraSearchEngines = {
    "gitlab (stamus)" = {
      urls = [{
        template = "https://git.stamus-networks.com/search";
        params = [
          { name = "search"; value = "{searchTerms}"; }
        ];
      }];
      icon = "https://git.stamus-networks.com/assets/favicon.png";
      definedAliases = [ "@sgl" ];
    };
  };

  users = {
    lanath = {
      username = "lanath";
      homeDir = "/home/lanath";
      # Password hash lives in sops as `lanath_password`.
      sshKeyFiles = [ "lanath.pub" "id_ed25519.pub" ];
      git = {
        name = "lanath";
        personalEmail = "valentin@viviersoft.com";
        gpgKey = "B3319E23B4F37099073FD764AC81A86C4854A64B";
        signByDefault = true;
        workDir = "Work/stamus";
        workEmail = "vvivier@stamus-networks.com";
      };
    };
    mushu = {
      username = "mushu";
      homeDir = "/home/mushu";
      # Password hash lives in sops as `mushu_password`.
      sshKeyFiles = [ "mushu.pub" "id_ed25519.pub" ];
      git = {
        name = "mushu";
        personalEmail = "contact@marieforja.com";
        gpgKey = "F54E5E007F0EE47C1F2F4B2486E1F5832C3882A6";
        signByDefault = false;
        workDir = "Work/masterMonkeys";
        workEmail = "";
      };
    };
  };
}
