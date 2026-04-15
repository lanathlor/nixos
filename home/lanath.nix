{ nur, ... }: {
  imports = [
    ./programs/basics/lanath.nix
    ./programs/browsers/lanath.nix
    ./programs/fish/lanath.nix
    ./programs/git/lanath.nix
    ./programs/hyprland/lanath.nix
    ./programs/rofi/lanath.nix
    ./programs/starship/lanath.nix
    ./programs/swaylock/lanath.nix
    ./programs/neovim/lanath.nix
    ./programs/opencode/lanath.nix
    ./programs/vscode/lanath.nix
    ./programs/xdg/lanath.nix
    ./services/dunst
    ./themes

    nur.modules.homeManager.default
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
