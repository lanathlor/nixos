{ nur, ... }: {
  imports = [
    ./programs/basics
    ./programs/browsers
    ./programs/fish
    ./programs/git
    ./programs/hyprland
    ./programs/rofi
    ./programs/starship
    ./programs/swaylock
    ./programs/neovim
    ./programs/opencode
    ./programs/nyxt
    ./programs/vscode
    ./programs/xdg
    ./services/dunst
    ./services/wayvnc
    ./themes

    nur.modules.homeManager.default
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
