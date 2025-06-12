{ setDefault }:
{ pkgs, lib, stamusctl, ... }:
{
  users.defaultUserShell = lib.mkIf setDefault pkgs.fish;
  environment.shells = [ pkgs.fish ];

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
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
  ];
}
