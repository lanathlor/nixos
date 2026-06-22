{ pkgs, lib, localConfig, ... }:
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
  ++ lib.optional localConfig.xrdp.enable ../modules/services/xrdp
  ++ lib.optional localConfig.sunshine.enable ../modules/services/sunshine;

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
    # thin client: greetd auto-starts a fullscreen Moonlight session streaming the
    # configured Sunshine host, inside a bare cage compositor (no local hotkeys, so
    # every key passes through to the remote session). No local login prompt.
    (lib.mkIf localConfig.kioskClient.enable {
      kiosk.configuration =
        let
          moonlight = "${pkgs.moonlight-qt}/bin/moonlight";
          # Runs inside cage (has a Wayland display for Qt). If already paired with
          # Sunshine, stream the Desktop app directly; otherwise open the Moonlight
          # UI to pair (one-time PIN at https://<host>:47990).
          kioskInner = pkgs.writeShellScript "kiosk-moonlight-inner" ''
            host=${localConfig.kioskClient.host}
            if ${moonlight} list "$host" >/dev/null 2>&1; then
              exec ${moonlight} stream "$host" "Desktop" --resolution ${localConfig.kioskClient.resolution}
            else
              exec ${moonlight}
            fi
          '';
          kioskLauncher = pkgs.writeShellScript "kiosk-moonlight" ''
            exec ${lib.getExe pkgs.cage} -s -- ${kioskInner}
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
