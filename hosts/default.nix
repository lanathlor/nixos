{ pkgs, lib, config, localConfig, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../modules/system
    ../modules/system/user
    ../modules/system/virt/docker.nix
    ../modules/system/virt/kubernetes.nix

    ../modules/games
    ../modules/nix

    ../modules/rice
    ../modules/rice/de/hyprland.nix
    ../modules/rice/theme/nordic

    ../modules/services/ssh
    ../modules/services/traefik
  ]
  ++ lib.optional localConfig.llm.enable ../modules/services/llm
  ++ lib.optional localConfig.qemu.enable ../modules/system/virt/qemu.nix
  ++ lib.optional localConfig.gnome.enable ../modules/rice/de/gnome.nix
  ++ lib.optional localConfig.kde.enable ../modules/rice/de/kde.nix
  ++ lib.optional localConfig.nvidia.enable ../modules/system/nvidia
  ++ lib.optional localConfig.wayvnc.enable ../modules/services/wayvnc
  ++ lib.optional localConfig.xrdp.enable ../modules/services/xrdp;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [ linux-firmware ];

  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  networking.hostName = localConfig.hostName;

  modules.games.warcraftlogs.enable = true;
  modules.games.wago-addons.enable = true;

  systemd.targets.time-sync.wantedBy = [ "multi-user.target" ];

  specialisation = lib.mkMerge [
    # Headless specialisation — switch-to-headless / switch-to-desktop scripts
    (lib.mkIf localConfig.headless.enable {
      headless.configuration = {
        services.xserver.enable = lib.mkForce false;
        services.displayManager.gdm.enable = lib.mkForce false;
        programs.hyprland.enable = lib.mkForce false;
      };
    })

    # Kiosk client specialisation — a boot entry that turns this machine into a
    # thin client: greetd auto-starts a fullscreen RDP session to the configured
    # KDE (xrdp) host, with no local login prompt.
    (lib.mkIf localConfig.kioskClient.enable {
      kiosk.configuration =
        let
          kioskLauncher = pkgs.writeShellScript "kiosk-rdp" ''
            exec ${lib.getExe pkgs.cage} -s -- \
              ${pkgs.freerdp}/bin/wlfreerdp \
                /v:${localConfig.kioskClient.host} \
                /u:${localConfig.kioskClient.user} \
                /p:"$(cat ${config.sops.secrets.kiosk_rdp_password.path})" \
                /cert:ignore +clipboard /f
          '';
        in
        {
          services.greetd.settings.initial_session = lib.mkForce {
            command = "${kioskLauncher}";
            user = localConfig.kioskClient.localUser;
          };
        };
    })
  ];

  environment.systemPackages = lib.mkIf localConfig.headless.enable (with pkgs; [
    (writeShellScriptBin "switch-to-headless" ''
      exec sudo /run/current-system/specialisation/headless/bin/switch-to-configuration switch
    '')
    (writeShellScriptBin "switch-to-desktop" ''
      exec sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
    '')
  ]);
}
