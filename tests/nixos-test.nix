# NixOS VM integration test
# Tests that a minimal system boots and core functionality works
{ pkgs, ... }:

pkgs.testers.nixosTest {
  name = "system-validation";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      # Minimal VM config
      virtualisation.graphics = false;
      virtualisation.memorySize = 1024;

      # Apply same locale settings as production
      time.timeZone = "Europe/Paris";
      i18n.defaultLocale = "en_US.UTF-8";

      # Nix configuration (simplified, no network deps)
      nix = {
        package = pkgs.nixVersions.stable;
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
        settings = {
          trusted-users = [ "testuser" "root" ];
        };
      };

      # Create test user
      users.users.testuser = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" ];
      };

      # Core packages from your config
      environment.systemPackages = with pkgs; [
        git
        curl
        vim
        tmux
        htop
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    with subtest("System boots successfully"):
        status = machine.succeed("systemctl is-system-running --wait || true")
        assert "running" in status or "degraded" in status, f"System not healthy: {status}"

    with subtest("User management works"):
        machine.succeed("id testuser")
        machine.succeed("groups testuser | grep -q wheel")

    with subtest("Locale is configured correctly"):
        locale_output = machine.succeed("locale")
        assert "en_US.UTF-8" in locale_output, f"Wrong locale: {locale_output}"

    with subtest("Timezone is set"):
        tz = machine.succeed("timedatectl show -p Timezone --value").strip()
        assert tz == "Europe/Paris", f"Wrong timezone: {tz}"

    with subtest("Nix flakes enabled"):
        machine.succeed("nix --version")
        # Verify flakes work
        machine.succeed("nix flake --help")

    with subtest("Core packages available"):
        machine.succeed("which git")
        machine.succeed("which curl")
        machine.succeed("which vim")
        machine.succeed("which tmux")
        machine.succeed("which htop")

    with subtest("Network stack functional"):
        machine.succeed("ip addr")
        machine.succeed("ping -c 1 127.0.0.1")
  '';
}
