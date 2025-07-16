{ pkgs, pkgs-unstable, stamusctl, ... }:
{
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
    htop
    lxqt.lxqt-openssh-askpass
    ssh-askpass-fullscreen
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
    noto-fonts-emoji
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

    pkgs-unstable.claude-code

    stamusctl.packages.${pkgs.system}.default
  ];
}
