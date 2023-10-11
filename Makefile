
env:
	sudo nixos-rebuild switch -I "nixos-config=config/$(NIX_CONFIG_USER)/configuration.nix"

lanath-laptop:
	sudo nixos-rebuild switch -I nixos-config=config/lanath-laptop/configuration.nix

garbage:
	sudo nix-collect-garbage

wipe:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage