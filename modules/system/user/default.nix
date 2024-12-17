{ username, initialHashedPassword }:
{ config, pkgs, lib, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" ];
    initialHashedPassword = "***REMOVED-PASSWORD-HASH***";
    openssh.authorizedKeys.keyFiles = [ builtins.toPath "../../keys/${username}.pub" ];
  };
}
