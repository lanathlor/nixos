{ username, initialHashedPassword, sshKeyFiles }:
{ ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" ];
    inherit initialHashedPassword;
    openssh.authorizedKeys.keyFiles = sshKeyFiles;
  };
}
