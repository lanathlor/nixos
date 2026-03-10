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
    enableAskPassword = false;
  };

  programs.gnupg.agent.enable = false;
}
