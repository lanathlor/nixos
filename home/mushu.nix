{ nur, ... }: {
  imports = [
    ./programs/basics/lanath.nix
    ./programs/browsers/lanath.nix
    ./programs/fish/lanath.nix
    ./programs/git/mushu.nix
    ./programs/hyprland/lanath.nix
    ./programs/rofi/lanath.nix
    ./programs/starship/lanath.nix
    ./programs/swaylock/lanath.nix
    ./programs/vscode/lanath.nix
    ./programs/xdg/lanath.nix
    ./services/dunst
    ./themes/nordic

    nur.modules.homeManager.default
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
