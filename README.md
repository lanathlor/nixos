# NixOS Configuration

Generic NixOS flake with Hyprland, Home Manager, and sops-nix secrets management. Supports multiple users and optional modules via feature flags.

## Quick Start

```bash
git clone <this-repo> /etc/nixos
cd /etc/nixos

# Generate hardware config
nixos-generate-config --show-hardware-config > hosts/hardware-configuration.nix

# Edit local.nix with your personal data (users, emails, SSH keys, etc.)
$EDITOR local.nix

# Add your SSH public keys
cp ~/.ssh/id_ed25519.pub keys/mykey.pub

# Prevent accidental commits of personal data
git update-index --skip-worktree local.nix hosts/hardware-configuration.nix

# Build and switch
sudo nixos-rebuild switch --flake .#default
```

## Configuration

All personal data lives in `local.nix` — override any value from `config-defaults.nix`:

```nix
{
  hostName = "my-machine";
  users.myuser = {
    username = "myuser";
    homeDir = "/home/myuser";
    hashedPassword = "...";  # mkpasswd -m yescrypt
    sshKeyFiles = [ "mykey.pub" ];
    git = {
      name = "My Name";
      personalEmail = "me@example.com";
    };
  };
  llm.enable = true;       # ROCm LLM inference
  qemu.enable = true;      # KVM virtualisation
  vscodeServer.enable = true;
}
```

See `config-defaults.nix` for all available options and their defaults.

## Feature Flags

| Flag | Description |
|------|-------------|
| `llm.enable` | llama.cpp with ROCm (AMD GPU) |
| `qemu.enable` | QEMU/KVM + libvirtd |
| `gnome.enable` | GNOME alongside Hyprland |
| `vscodeServer.enable` | VS Code remote server |
| `headless.enable` | Headless specialisation with switch scripts |
| `nvidia.enable` | Nvidia PRIME hybrid graphics |

## Secrets Management

Uses [sops-nix](https://github.com/Mic92/sops-nix) for API keys and tokens.

```bash
# Generate age key
sudo mkdir -p /var/lib/sops-nix
sudo age-keygen -o /var/lib/sops-nix/key.txt

# Copy and configure sops
cp .sops.example.yaml .sops.yaml
# Set your age public key in .sops.yaml

# Create and encrypt secrets
cp secrets/secrets.yaml.example secrets/secrets.yaml
sops -e -i secrets/secrets.yaml
```

## Structure

```
flake.nix                   Entry point — single nixosConfiguration
config-defaults.nix         Schema and defaults (upstream-maintained)
local.nix                   Your personal overrides
hosts/
  default.nix               Host config with feature-flag imports
  hardware-configuration.nix  Machine-specific (generate per machine)
modules/
  games/                    Gaming (Steam, WoW addons)
  nix/                      Nix daemon settings
  rice/                     Desktop environment (Hyprland, themes)
  services/                 System services (SSH, Traefik, LLM)
  system/                   Core system (users, virtualisation)
home/
  default.nix               Home Manager entry point (shared by all users)
  programs/                 Per-program configs
  services/                 Per-service configs (Dunst)
  themes/                   Theme system
overlays/                   Custom package overlays
keys/                       SSH public keys (gitignored)
```

## Commands

| Command | Description |
|---------|-------------|
| `make switch` | Rebuild and switch |
| `make update` | Update flake inputs |
| `make clean` | Remove old generations |
| `just check` | Run flake checks |
| `just test` | Run VM integration tests |
| `just eval` | Verify config evaluates |
