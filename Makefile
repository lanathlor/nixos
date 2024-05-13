#####
##### desk|lap top
#####

env:
	sudo nixos-rebuild switch -I "nixos-config=config/$(NIX_CONFIG_USER)/configuration.nix"

lanath-laptop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-laptop/configuration.nix

mushu-laptop:
	sudo nixos-rebuild switch -I nixos-config=config/mushu-laptop/configuration.nix

lanath-desktop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-desktop/configuration.nix

build-lanath-iso:
	nixos-generate -f iso -c config/lanath-laptop/configuration.nix

basic:
	sudo nixos-rebuild switch -I nixos-config=config/basic/configuration.nix

#####
##### misc
#####

update:
	sudo nix-channel --update

upgrade:
	sudo nixos-rebuild boot -I "nixos-config=config/$(NIX_CONFIG_USER)/configuration.nix" --upgrade

re: update upgrade

garbage:
	sudo nix-collect-garbage

wipe:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage

all: clean re
