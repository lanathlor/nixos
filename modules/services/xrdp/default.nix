{ lib, localConfig, ... }:
{
  # xrdp — RDP server that spawns a fresh, independent Plasma session per remote
  # connection (not a mirror of the physical screen). Authenticates via PAM against
  # real system users, so no extra secret is needed on this side. Reachable directly
  # on the LAN (TCP 3389). Requires kde.enable so that `startplasma-x11` exists.
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = true;
  };

  assertions = [
    {
      assertion = localConfig.kde.enable;
      message = "xrdp.enable requires kde.enable (xrdp launches startplasma-x11, provided by Plasma).";
    }
  ];
}
