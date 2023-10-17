#####
##### desk|lap top
#####

env:
	sudo nixos-rebuild switch -I "nixos-config=config/$(NIX_CONFIG_USER)/configuration.nix"

lanath-laptop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-laptop/configuration.nix

lanath-desktop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-desktop/configuration.nix

build-lanath-iso:
	nixos-generate -f iso -c config/lanath-laptop/configuration.nix


#####
##### servers
#####

# saga is dns, vpn
saga:
	NIX_SSHOPTS="-tt" nixos-rebuild --target-host lanath@192.168.3.11 --use-remote-sudo switch -I nixos-config=servers/saga/configuration.nix

#####
##### misc
#####

update:
	sudo nix-channel --update

re: update env

garbage:
	sudo nix-collect-garbage

wipe:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage

all: clean re
