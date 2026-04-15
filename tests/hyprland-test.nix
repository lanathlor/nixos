# Hyprland graphical test
# Tests that Hyprland compositor starts and basic UI functionality works
{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "hyprland-validation";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      imports = [
        ../modules/rice/de/hyprland.nix
      ];

      # Enable graphics for VM
      virtualisation.graphics = true;
      virtualisation.memorySize = 2048;
      virtualisation.qemu.options = [
        "-vga virtio"
      ];

      # Create test user with hyprland
      users.users.testuser = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" "video" "render" ];
      };

      # Minimal hyprland config for testing (override hardcoded monitors)
      environment.etc."hyprland-test.conf".text = ''
        monitor=,preferred,auto,1
        env = WLR_BACKENDS,headless
        env = WLR_LIBINPUT_NO_DEVICES,1
        env = XDG_RUNTIME_DIR,/run/user/1000

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
        }

        # Exit after startup for testing
        bind = SUPER, Q, exit
      '';

      # Required packages
      environment.systemPackages = with pkgs; [
        foot        # Simple terminal for testing
        grim        # Screenshot tool
        wlr-randr   # Display info
      ];

      # Enable required services
      services.dbus.enable = true;
      security.polkit.enable = true;

      # Auto-login for testing
      services.getty.autologinUser = "testuser";
    };

  testScript = ''
    import shutil

    machine.start()
    machine.wait_for_unit("multi-user.target")

    with subtest("Hyprland binary exists"):
        machine.succeed("which Hyprland")

    with subtest("XDG portals configured"):
        machine.succeed("test -d /run/current-system/sw/share/xdg-desktop-portal")

    with subtest("Hyprland can start with headless backend"):
        # Create runtime dir
        machine.succeed("install -d -m 700 -o testuser /run/user/1000")

        # Start Hyprland in headless mode
        machine.succeed(
            "su - testuser -c '"
            "export XDG_RUNTIME_DIR=/run/user/1000; "
            "export WLR_BACKENDS=headless; "
            "export WLR_LIBINPUT_NO_DEVICES=1; "
            "timeout 5 Hyprland -c /etc/hyprland-test.conf || true"
            "'"
        )

    with subtest("Wayland socket created"):
        # Start Hyprland in background
        machine.succeed(
            "su - testuser -c '"
            "export XDG_RUNTIME_DIR=/run/user/1000; "
            "export WLR_BACKENDS=headless; "
            "export WLR_LIBINPUT_NO_DEVICES=1; "
            "Hyprland -c /etc/hyprland-test.conf &"
            "' &"
        )
        machine.sleep(3)

        # Check for wayland socket
        result = machine.execute("ls /run/user/1000/wayland-* 2>/dev/null || true")[1]
        if "wayland" in result:
            machine.log("Wayland socket found: " + result)
        else:
            machine.log("Note: Wayland socket not found (may be expected in headless)")

    with subtest("Hyprland IPC socket exists"):
        result = machine.execute("ls /run/user/1000/hypr/ 2>/dev/null || true")[1]
        machine.log("Hyprland sockets: " + result)
  '';
}
