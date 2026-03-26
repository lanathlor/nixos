{ ... }:
let
  profile = import ../../../users/mushu/profile.nix;
  keysDir = ../../../keys;
  sshKeyFiles = map (f: keysDir + "/${f}") profile.sshKeyFiles;
in
{
  imports = [
    (import ./default.nix {
      username = profile.username;
      initialHashedPassword = profile.hashedPassword;
      inherit sshKeyFiles;
    })
  ];
}
