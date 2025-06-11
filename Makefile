#####
##### desk|lap top
#####

env:
	sudo nixos-rebuild switch --flake .#$(NIX_CONFIG_USER)

mushu-laptop:
	sudo nixos-rebuild switch --flake .#mushu-laptop

lanath-desktop:
	sudo nixos-rebuild switch --flake .#lanath-desktop

mushu-desktop:
	sudo nixos-rebuild switch --flake .#mushu-desktop

#####
##### misc
#####

update:
	sudo nix-channel --update

upgrade:
	sudo nixos-rebuild boot --flake .#$(NIX_CONFIG_USER) --upgrade

re: update upgrade

garbage:
	sudo nix-collect-garbage

wipe:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage

all: re clean
