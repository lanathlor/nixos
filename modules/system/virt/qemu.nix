{ pkgs, localConfig, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu
  ];

  virtualisation.libvirtd.enable = true;
  users.users = builtins.mapAttrs (name: _: {
    extraGroups = [ "libvirtd" ];
  }) localConfig.users;
}
