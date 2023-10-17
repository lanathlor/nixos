{ config, pkgs, lib, ... }:
{

  imports = [
    (import "${home-manager}/nixos")
  ];

  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "saga";
    networkmanager = {
      enable = true;
    };
    useDHCP = true;
    nameservers = [ "192.168.3.1" "1.1.1.1" "8.8.8.8" ];
  };

  time.timeZone = ="Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";


  programs.ssh = {
    startAgent = true;
  };

  programs.gnupg.agent.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.mullvad-vpn.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.defaultUserShell = pkgs.fish;
  environment.shells = [ pkgs.fish ];

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    # ide
    vim

    # terms
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.autopair
    fishPlugins.bass
    fzf
    fishPlugins.grc
    grc
    fishPlugins.z

    # dev
    git

    # utils
    htop

    # maintenance
    zip
    unzip
    lshw
    xorg.xhost
    libva-utils
    acpi
    fd
    sptk
    bat
    jq
    ripgrep
    yq
    killall
    lm_sensors
    s-tui
    dig
    ldm
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}