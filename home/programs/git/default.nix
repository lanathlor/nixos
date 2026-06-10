{ config, localConfig, lib, ... }:
let
  profile = localConfig.users.${config.home.username};
  hasWorkDir = profile.git.workDir != "";
  hasWorkEmail = profile.git.workEmail or "" != "";
  hasGpgKey = profile.git.gpgKey != "";
in
{
  programs.git = {
    enable = true;
    userName = profile.git.name;
    userEmail = profile.git.personalEmail;
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
      pull.rebase = true;
    } // lib.optionalAttrs hasWorkDir {
      includeIf."gitdir:${profile.homeDir}/${profile.git.workDir}/**".path =
        "${profile.homeDir}/.config/git/config-work";
    };
    signing = lib.mkIf (profile.git.signByDefault or false) {
      signByDefault = true;
      key = profile.git.gpgKey;
    };
  };

  xdg.configFile."git/config-work" = lib.mkIf hasWorkDir {
    text = lib.concatStringsSep "\n" (
      lib.optional hasWorkEmail ''
        [user]
          email = ${profile.git.workEmail}''
      ++ lib.optional hasGpgKey ''
        [commit]
          gpgSign = true
        [user]
          signingKey = ${profile.git.gpgKey}''
    );
  };
}
