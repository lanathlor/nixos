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

# testing

check:
    nix flake check

test:
    nix build .#checks.x86_64-linux.vm-test --print-build-logs

test-interactive:
    nix build .#checks.x86_64-linux.vm-test.driverInteractive
    ./result/bin/nixos-test-driver

test-hyprland:
    nix build .#checks.x86_64-linux.hyprland-test --print-build-logs

test-hyprland-interactive:
    nix build .#checks.x86_64-linux.hyprland-test.driverInteractive
    ./result/bin/nixos-test-driver

eval:
    nix eval .#nixosConfigurations.default.config.system.build.toplevel --raw > /dev/null && echo "default: OK"
