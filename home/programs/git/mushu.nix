{ ... }:
let
  profile = import ../../../users/mushu/profile.nix;
in
{
  programs.git = {
    enable = true;
    settings.user.name = profile.git.name;
    settings.user.email = profile.git.personalEmail;
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
      includeIf."gitdir:${profile.homeDir}/${profile.git.workDir}/**".path = "${profile.homeDir}/.config/git/config-mastermonkeys";
      pull.rebase = true;
    };
  };

  xdg.configFile."git/config-mastermonkeys".text = ''
    [commit]
      gpgSign = true
    [user]
      signingKey = ${profile.git.gpgKey}
  '';
}
