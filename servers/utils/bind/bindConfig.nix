
{ config, pkgs, lib, ... }:

{
  services.bind = {
    enable = true;
    zones = {
      "bhc-it.internal" = {
        file = ./bhc-it.internal;
        master = true;
      };
    };
  };
}