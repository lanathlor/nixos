{ ... }:
let
  homeDir = "/home/mushu";
in
{
  programs.git = {
    enable = true;
    settings.user.name = "mushu";
    settings.user.email = "contact@marieforja.com";
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
      ".claude"
    ];
    settings = {
      includeIf."gitdir:${homeDir}/Work/masterMonkeys/**".path = "${homeDir}/.config/git/config-mastermonkeys";
      pull.rebase = true;
    };
  };

  xdg.configFile."git/config-mastermonkeys".text = ''
    [commit]
      gpgSign = true
    [user]
      signingKey = F54E5E007F0EE47C1F2F4B2486E1F5832C3882A6
  '';
}
