NIX_CONFIG_USER := `echo ${NIX_CONFIG_USER:-lanath-desktop}`

# #####
# ##### desk|lap top
# #####

env:
    sudo nixos-rebuild switch --flake .#{{NIX_CONFIG_USER}}

lanath-laptop:
    sudo nixos-rebuild switch --flake .#lanath-laptop

mushu-laptop:
    sudo nixos-rebuild switch --flake .#mushu-laptop

lanath-desktop:
    sudo nixos-rebuild switch --flake .#lanath-desktop

mushu-desktop:
    sudo nixos-rebuild switch --flake .#mushu-desktop

# #####
# ##### misc
# #####

update:
    nix flake update

upgrade:
    sudo nixos-rebuild boot --flake .#{{NIX_CONFIG_USER}} --upgrade

re: update upgrade

garbage:
    nix-collect-garbage

wipe:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d

clean: wipe garbage

# #####
# ##### testing
# #####

# Run all checks (eval + VM test)
check:
    nix flake check

# Run only VM integration test
test:
    nix build .#checks.x86_64-linux.vm-test --print-build-logs

# Run VM test interactively (for debugging)
test-interactive:
    nix build .#checks.x86_64-linux.vm-test.driverInteractive
    ./result/bin/nixos-test-driver

# Run Hyprland graphical test
test-hyprland:
    nix build .#checks.x86_64-linux.hyprland-test --print-build-logs

# Run Hyprland test interactively
test-hyprland-interactive:
    nix build .#checks.x86_64-linux.hyprland-test.driverInteractive
    ./result/bin/nixos-test-driver

# Verify all configs evaluate without building
eval:
    nix eval .#nixosConfigurations.lanath-desktop.config.system.build.toplevel --raw > /dev/null && echo "lanath-desktop: OK"
    nix eval .#nixosConfigurations.lanath-laptop.config.system.build.toplevel --raw > /dev/null && echo "lanath-laptop: OK"
    nix eval .#nixosConfigurations.mushu-desktop.config.system.build.toplevel --raw > /dev/null && echo "mushu-desktop: OK"
    nix eval .#nixosConfigurations.mushu-laptop.config.system.build.toplevel --raw > /dev/null && echo "mushu-laptop: OK"

