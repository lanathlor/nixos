switch:
	sudo nixos-rebuild switch --flake .#default

update:
	nix flake update

upgrade:
	sudo nixos-rebuild boot --flake .#default --upgrade

re: update upgrade

garbage:
	nix-collect-garbage

wipe:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage

all: re clean
