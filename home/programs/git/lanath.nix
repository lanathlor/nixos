{ ... }:
let
  homeDir = "/home/lanath";
in
{
  programs.git = {
    enable = true;
    userName = "lanath";
    ignores = [
      "node_modules"
      "out"
      "*.log"
      "*.sqlite"
      "*.envrc"
      "*.pem"
      "*.key"
      "*.crt"
      "*.csr"
      "*.pfx"
      "*.cer"
      "*.jks"
      "*.keystore"
      "*~"
      ".direnv"
      ".envrc"
      "*tfstate*"
      ".terraform"
    ];
    extraConfig = {
      includeIf."gitdir:${homeDir}/**".path = "${homeDir}/.config/git/config-personal";
      includeIf."gitdir:${homeDir}/Work/stamus/**".path = "${homeDir}/.config/git/config-work";
      pull.rebase = true;
    };
    signing = {
      signByDefault = true;
      key = "B3319E23B4F37099073FD764AC81A86C4854A64B";
    };
  };

  xdg.configFile."git/config-personal".text = ''
    [user]
      email = valentin@viviersoft.com
  '';

  xdg.configFile."git/config-work".text = ''
    [user]
      email = vvivier@stamus-networks.com
  '';
}
