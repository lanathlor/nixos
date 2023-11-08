{ config, pkgs, lib, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../utils/bind/bindConfig.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # nix.nixPath = [
  #   "nixos-config=/etc/styx/servers/styx/configuration.nix"
  # ];
  environment.etc."styx".source = builtins.fetchGit {
    url = "https://github.com/lanathlor/nixos";
  };

  environment.sessionVariables.NIX_CONFIG_USER = "styx";
  environment.sessionVariables.TERM = "xterm";

  system.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;


  networking = {
    hostName = "styx";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Paris";

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

  services.logind.lidSwitch = "ignore";

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  environment.shells = [ pkgs.fish ];

  programs.fish.enable = true;
  programs.starship.enable = true;

  environment.systemPackages = with pkgs; [
    # ide
    vim

    # terms
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
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

  nix.settings.trusted-users = [ "lanath" ];
  users.users.lanath = {
    isNormalUser = true;
    description = "lanath";
    extraGroups = [ "networkmanager" "wheel" "storage" ];
    initialHashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";
    openssh.authorizedKeys.keyFiles = [ ./lanath.pub ];
    packages = with pkgs; [
    ];
  };
  users.users.styx = {
    isNormalUser = true;
    description = "styx";
    extraGroups = [  ];
    openssh.authorizedKeys.keyFiles = [ ./lanath.pub ];
    packages = with pkgs; [
    ];
  };
}
