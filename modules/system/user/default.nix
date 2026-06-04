{ username, initialHashedPassword, sshKeyFiles }:
{ ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" "video" "render" ];
    inherit initialHashedPassword;
    openssh.authorizedKeys.keyFiles = sshKeyFiles;
  };
}
