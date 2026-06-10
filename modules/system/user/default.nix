{ localConfig, lib, ... }:
let
  keysDir = ../../../keys;
  mkKeyFiles = userCfg:
    builtins.filter builtins.pathExists
      (map (f: keysDir + "/${f}") userCfg.sshKeyFiles);
  allKeyFiles =
    builtins.filter builtins.pathExists
      (builtins.concatMap
        (u: map (f: keysDir + "/${f}") u.sshKeyFiles)
        (builtins.attrValues localConfig.users));
in
{
  users.users = (builtins.mapAttrs (name: userCfg: {
    isNormalUser = true;
    description = name;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" "video" "render" ];
    initialHashedPassword = userCfg.hashedPassword;
    openssh.authorizedKeys.keyFiles = mkKeyFiles userCfg;
  }) localConfig.users) // {
    root = {
      isNormalUser = lib.mkForce false;
      openssh.authorizedKeys.keyFiles = allKeyFiles;
    };
  };
}
