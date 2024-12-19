{ pkgs, ... }:
{
  security.rtkit.enable = true;
  security.polkit.enable = true;

  security.pam.services = {
    swaylock = { };
    kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };
    sddm.enableKwallet = true;
    login.enableKwallet = true;
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };

  programs.gnupg.agent.enable = true;
}
