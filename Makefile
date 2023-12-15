#####
##### desk|lap top
#####

env:
	sudo nixos-rebuild switch -I "nixos-config=config/$(NIX_CONFIG_USER)/configuration.nix" --upgrade

lanath-laptop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-laptop/configuration.nix

mushu-laptop:
	sudo nixos-rebuild switch -I nixos-config=config/mushu-laptop/configuration.nix

lanath-desktop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-desktop/configuration.nix

build-lanath-iso:
	nixos-generate -f iso -c config/lanath-laptop/configuration.nix


#####
##### servers
#####

# saga is dns, vpn
saga:
	NIX_SSHOPTS="-tt" nixos-rebuild --target-host lanath@10.0.0.2 --use-remote-sudo switch -I nixos-config=servers/saga/configuration.nix

# mimir is kube master, prom master
mimir:
	NIX_SSHOPTS="-tt" nixos-rebuild --target-host lanath@10.0.0.2 --use-remote-sudo switch -I nixos-config=servers/mimir/configuration.nix

styx:
	NIX_SSHOPTS="-tt" nixos-rebuild --target-host lanath@10.1.0.1 --use-remote-sudo switch -I nixos-config=servers/styx/configuration.nix

helios:
	NIX_SSHOPTS="-tt" nixos-rebuild --target-host lanath@10.1.0.2 --use-remote-sudo switch -I nixos-config=servers/helios/configuration.nix


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
