{ ... }:
{
  users.users.root = {
    isNormalUser = false;
    openssh.authorizedKeys.keyFiles = [ ../../keys/lanath.pub ../../keys/mushu.pub ];
  };
}
