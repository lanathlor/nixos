{ pkgs, ... }:
{
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };

  programs.gnupg.agent.enable = true;
}
