
env:
	sudo nixos-rebuild switch -I "nixos-config=config/$(NIX_CONFIG_USER)/configuration.nix"

lanath-laptop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-laptop/configuration.nix

lanath-desktop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-desktop/configuration.nix 

imsike-desktop:
	sudo nixos-rebuild switch -I nixos-config=config/imsike-desktop/configuration.nix

build-lanath-iso:
	nixos-generate -f iso -c config/lanath-laptop/configuration.nix

update:
	sudo nix-channel --update

garbage:
	sudo nix-collect-garbage

wipe:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage
