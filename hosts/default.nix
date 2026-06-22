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

    # Kiosk client specialisation — a boot entry for a thin-client laptop. greetd
    # autostarts a minimal local Hyprland session: Moonlight runs fullscreen on the
    # external monitor (streaming the Sunshine host) while the laptop's built-in
    # screen stays a normal local desktop, so a local video call and the remote
    # desktop run side by side. No persistent local login prompt.
    (lib.mkIf localConfig.kioskClient.enable {
      kiosk.configuration =
        let
          cfg = localConfig.kioskClient;
          moonlight = "${pkgs.moonlight-qt}/bin/moonlight";
          hyprctl = "${pkgs.hyprland}/bin/hyprctl";
          jq = "${pkgs.jq}/bin/jq";

          # Launch Moonlight and park it fullscreen on the external monitor (keeping
          # the laptop screen free for a local call). If Sunshine isn't paired yet,
          # open the Moonlight UI instead (one-time PIN at https://<host>:47990).
          # --absolute-mouse: desktop-optimised pointer so the cursor can leave the
          # stream onto the laptop screen. Borderless so it behaves like a window.
          kioskStream = pkgs.writeShellScript "kiosk-stream" ''
            set -u
            host=${cfg.host}

            if ! ${moonlight} list "$host" >/dev/null 2>&1; then
              exec ${moonlight}            # not paired yet — open UI to enter the PIN
            fi

            # External output: explicit override > first non-eDP > first monitor.
            ext="${cfg.streamOutput}"
            if [ -z "$ext" ]; then
              ext=$(${hyprctl} -j monitors | ${jq} -r '[.[]|select(.name|test("eDP")|not)]|.[0].name // empty')
            fi
            [ -z "$ext" ] && ext=$(${hyprctl} -j monitors | ${jq} -r '.[0].name')

            # Once the Moonlight window appears, move it to the external and fullscreen it.
            (
              for _ in $(seq 1 80); do
                addr=$(${hyprctl} -j clients | ${jq} -r '.[]|select(.class|test("[Mm]oonlight"))|.address' | head -n1)
                [ -n "$addr" ] && break
                sleep 0.25
              done
              if [ -n "$addr" ] && [ -n "$ext" ]; then
                ${hyprctl} dispatch focuswindow "address:$addr"
                ${hyprctl} dispatch movewindow "mon:$ext"
                ${hyprctl} dispatch fullscreen 0
              fi
            ) &

            exec ${moonlight} stream "$host" "Desktop" \
              --display-mode borderless \
              --absolute-mouse \
              --no-quit-after \
              --keep-awake \
              --resolution ${cfg.resolution}
          '';

          # Minimal local Hyprland. Deliberately almost no keybinds: with nothing
          # bound to SUPER, those combos fall through to the focused Moonlight window
          # and reach the REMOTE desktop. Local actions live on CTRL+ALT so they never
          # shadow the remote's SUPER shortcuts. follow_mouse=1 means moving the pointer
          # to the laptop screen hands focus (and the keyboard) to local apps.
          kioskHyprConf = pkgs.writeText "kiosk-hyprland.conf" ''
            monitor = , preferred, auto, 1

            input {
                kb_layout = us
                follow_mouse = 1
                numlock_by_default = true
            }

            general {
                gaps_in = 0
                gaps_out = 0
                border_size = 1
                layout = dwindle
            }

            decoration {
                rounding = 0
            }

            misc {
                disable_hyprland_logo = true
                disable_splash_rendering = true
            }

            animations {
                enabled = no
            }

            # Local-only binds on CTRL+ALT (won't collide with the remote's SUPER binds).
            bind = CTRL ALT, T, exec, ${pkgs.kitty}/bin/kitty
            bind = CTRL ALT, Space, exec, ${pkgs.rofi}/bin/rofi -show drun
            bind = CTRL ALT, Q, killactive
            # Relaunch the stream if it was closed.
            bind = CTRL ALT, M, exec, ${kioskStream}
            # Drop back to the login screen.
            bind = CTRL ALT SHIFT, E, exit

            exec-once = ${kioskStream}
          '';

          kioskLauncher = pkgs.writeShellScript "kiosk-session" ''
            exec ${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/Hyprland --config ${kioskHyprConf}
          '';
        in
        {
          services.greetd.settings.initial_session = lib.mkForce {
            command = "${kioskLauncher}";
            user = cfg.localUser;
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
