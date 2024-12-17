{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nordic
    nordic.sddm
  ];
}
