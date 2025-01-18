#####
##### desk|lap top
#####

env:
	sudo nixos-rebuild switch -I "nixos-config=hosts/$(NIX_CONFIG_USER).nix"

mushu-laptop:
	nixos-rebuild switch -I nixos-config=hosts/mushu-laptop.nix

lanath-desktop:
	nixos-rebuild switch -I nixos-config=hosts/lanath-desktop.nix

mushu-desktop:
	nixos-rebuild switch -I nixos-config=hosts/mushu-desktop.nix

#####
##### misc
#####

update:
	sudo nix-channel --update

upgrade:
	sudo nixos-rebuild boot -I "nixos-config=hosts/$(NIX_CONFIG_USER).nix" --upgrade

re: update upgrade

garbage:
	sudo nix-collect-garbage

wipe:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage

all: re clean
