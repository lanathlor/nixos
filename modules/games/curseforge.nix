{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    curseforge
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "curseforge"
  ];
}
