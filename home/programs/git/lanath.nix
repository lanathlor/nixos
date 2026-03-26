{ ... }:
let
  profile = import ../../../users/lanath/profile.nix;
in
{
  programs.git = {
    enable = true;
    settings.user.name = profile.git.name;
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
      "CLAUDE.md"
      ".claude"
    ];
    settings = {
      includeIf."gitdir:${profile.homeDir}/**".path = "${profile.homeDir}/.config/git/config-personal";
      includeIf."gitdir:${profile.homeDir}/${profile.git.workDir}/**".path = "${profile.homeDir}/.config/git/config-work";
      pull.rebase = true;
    };
    signing = {
      signByDefault = profile.git.signByDefault;
      key = profile.git.gpgKey;
    };
  };

  xdg.configFile."git/config-personal".text = ''
    [user]
      email = ${profile.git.personalEmail}
  '';

  xdg.configFile."git/config-work".text = ''
    [user]
      email = ${profile.git.workEmail}
  '';
}
