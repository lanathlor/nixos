# config-defaults.nix — schema and defaults for all configurable values.
# Upstream-maintained. Users should NOT edit this file.
# Override any value in local.nix instead.
{
  # Hostname for this machine
  hostName = "nixos";

  # GitHub username/repo for the installer ISO
  githubUser = "your-github-username";
  githubRepo = "nixos";

  # Domain used for local dev (Traefik wildcard cert, dev-up script)
  localDomain = "local.example.com";

  # Extra /etc/hosts entries  { "ip" = [ "hostname" ... ]; }
  extraHosts = {};

  # Weather widget (waybar) — get a free key at https://openweathermap.org
  # The API key is stored in sops as `weather_appid`, not here.
  weather = {
    lat = "0.0";
    lon = "0.0";
  };

  # sops-nix age public key — generate with: age-keygen
  agePublicKey = "age1...";

  # --- Feature flags for optional modules ---

  # LLM inference (llama.cpp with ROCm) — needs AMD GPU
  llm.enable = false;

  # QEMU/KVM virtualisation
  qemu.enable = false;

  # GNOME desktop environment (in addition to Hyprland)
  gnome.enable = false;

  # KDE Plasma 6 desktop (selectable at login alongside Hyprland)
  kde.enable = false;

  # xrdp — RDP server exposing an independent KDE session over the LAN (needs kde.enable)
  xrdp.enable = false;

  # VS Code remote server
  vscodeServer.enable = false;

  # wayvnc — VNC server for Hyprland (access via SSH tunnel)
  wayvnc.enable = false;

  # Headless specialisation (switch-to-headless / switch-to-desktop scripts)
  headless.enable = false;

  # Nvidia PRIME (hybrid Intel + Nvidia GPU)
  nvidia = {
    enable = false;
    intelBusId = "";
    nvidiaBusId = "";
  };

  # Kiosk client — adds a "kiosk" boot entry that auto-connects via RDP to a remote
  # KDE (xrdp) host and shows a fullscreen Plasma session. No local login prompt.
  # Disabled on the desktop; enabled on thin-client devices (e.g. a laptop).
  # The RDP password is read at runtime from sops secret `kiosk_rdp_password`.
  kioskClient = {
    enable = false;
    host = "";        # hostname/IP of the desktop running xrdp
    user = "";        # RDP/system user to log into on the host
    localUser = "";   # local account greetd runs the kiosk session as
  };

  # --- Users ---
  # Add as many users as you need in local.nix.
  # Each key becomes a system + home-manager user.
  #
  # Example entry for local.nix:
  #   users.myuser = {
  #     username = "myuser";
  #     homeDir = "/home/myuser";
  #     # Password hash is stored in sops as `<username>_password`
  #     # (generate with: mkpasswd -m yescrypt), not in this file.
  #     sshKeyFiles = [ "myuser.pub" ];  # Filenames relative to keys/
  #     git = {
  #       name = "your-name";
  #       personalEmail = "you@example.com";
  #       gpgKey = "";                   # GPG key fingerprint for commit signing
  #       signByDefault = false;
  #       workDir = "";                  # Relative to homeDir — triggers separate git identity
  #       workEmail = "";
  #     };
  #   };

  users = {};

  # Extra browser search engines (work-specific)
  extraSearchEngines = {};
}
