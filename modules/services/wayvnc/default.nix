{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wayvnc
  ];
}
