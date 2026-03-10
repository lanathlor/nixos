{ pkgs, pkgs-unstable, stamusctl, ... }:
let
  dev-up = pkgs.writeShellScriptBin "dev-up" ''
    set -euo pipefail

    TOPLEVEL=$(git rev-parse --show-toplevel)
    PROJECT=$(basename "$TOPLEVEL" | tr '[:upper:]' '[:lower:]' | sed 's/[/_]/-/g')
    BRANCH=$(git rev-parse --abbrev-ref HEAD | tr '[:upper:]' '[:lower:]' | sed 's/[/_]/-/g')
    DOMAIN="''${BRANCH}.''${PROJECT}.local.dosismart.com"

    export PROJECT BRANCH DOMAIN

    echo "Project: $PROJECT"
    echo "Branch:  $BRANCH"
    echo "Domain:  $DOMAIN"
    echo ""

    docker compose --project-name "''${PROJECT}-''${BRANCH}" up -d
  '';
in
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      openssl
      zlib
      icu
    ];
  };

  services.mullvad-vpn.enable = true;
  environment.systemPackages = with pkgs; [
    # ide
    vim

    mullvad
    mullvad-vpn
    mullvad-browser

    # dev
    git
    nixpkgs-fmt
    nodejs_22
    pnpm

    # utils
    tmux
    htop
    nixfmt-rfc-style
    openvpn
    wireguard-tools
    mattermost-desktop
    tig
    brightnessctl

    dive

    nil

    # maintenance
    zip
    unzip
    lshw
    xorg.xhost
    libva-utils
    acpi
    fd
    pkgs-unstable.sptk
    bat
    jq
    ripgrep
    yq
    killall
    lm_sensors
    s-tui
    dig
    ldm
    pixcat
    arp-scan
    busybox
    nmap
    nftables
    iptables
    ethtool
    wireshark
    tcpreplay

    qemu

    pkgs-unstable.swww
    dmenu
    playerctl
    networkmanagerapplet
    xfce.orage
    baobab
    keepassxc
    kpcli
    gparted
    grim
    slurp
    wl-clipboard
    cliphist
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    font-awesome
    font-awesome_5
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.noto
    nomacs

    rocmPackages.clr
    rocmPackages.rocm-smi
    clinfo
    ocl-icd
    mesa
    mesa.opencl
    radeontop

    gcc

    claude-code
    codex

    pkgs-unstable.code-server

    xdg-utils

    pkgs-unstable.discord

    jetbrains.rider

    dev-up

    stamusctl.packages.${pkgs.system}.default
  ];
}
