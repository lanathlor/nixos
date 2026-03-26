# NixOS Configuration

Personal NixOS flake for two users across multiple machines, built with Home Manager.

## Features

- **Theme system** — 9 themes (Nord, Catppuccin, Dracula, Gruvbox, Tokyo Night, Everforest, Rose Pine, One Dark, Kanagawa) with live switching via `Super+Shift+Space`. Themes cover Waybar, Dunst, Kitty, Neovim, Starship, Rofi, GTK.
- **Hyprland** Wayland compositor
- **Programs** — Fish, Neovim, VSCode, Zen Browser, Rofi, Starship, tmux
- **Services** — SSH, Docker, Kubernetes (k3s), Traefik, Ollama (local LLM)
- **Gaming** — WoW addon managers (wago-addons, warcraftlogs, CurseForge)
- **Multi-user** — per-user Home Manager configs with separate identities

## Structure

```
flake.nix                     Entry point — nixosConfigurations
hosts/                        Per-machine configs + hardware configuration files
modules/
  games/                      Gaming-related modules (wago-addons, warcraftlogs)
  nix/                        Nix daemon settings
  rice/                       Desktop environment modules (Hyprland, GNOME, themes)
  services/                   System services (SSH, Traefik, Ollama)
  system/                     Core system config (users, virtualization)
home/
  <user>.nix                  Top-level Home Manager entry per user
  programs/                   Per-program HM configs
  services/                   Per-service HM configs (Dunst)
  themes/                     Theme system (registry, per-theme assets)
overlays/                     Custom package overlays
users/
  lanath/profile.nix          Personal data for user lanath (single source of truth)
  mushu/profile.nix           Personal data for user mushu
keys/                         SSH public keys (one file per user)
```

## Forking

### 1. Create a user profile

Copy an existing profile and fill in your data:

```bash
cp -r users/lanath users/<yourname>
$EDITOR users/<yourname>/profile.nix
```

Fields to update:
- `username` — your Unix username
- `homeDir` — your home directory (usually `/home/<username>`)
- `hashedPassword` — generate with `mkpasswd -m yescrypt`
- `sshKeyFiles` — list of filenames in `keys/` to authorize for SSH login
- `git.*` — name, email(s), GPG key fingerprint

Add your SSH public key(s) to `keys/`:

```bash
cp ~/.ssh/id_ed25519.pub keys/<yourname>.pub
```

### 2. Add a system user module

```bash
cp modules/system/user/lanath.nix modules/system/user/<yourname>.nix
# Edit the import path to point to your profile
$EDITOR modules/system/user/<yourname>.nix
```

### 3. Add a Home Manager config

```bash
cp home/lanath.nix home/<yourname>.nix
$EDITOR home/<yourname>.nix
```

Copy and adjust the per-program configs under `home/programs/` as needed.

### 4. Create a host

```bash
cp hosts/lanath-desktop.nix hosts/<hostname>.nix
$EDITOR hosts/<hostname>.nix
```

Generate your hardware configuration:

```bash
nixos-generate-config --show-hardware-config > hosts/<hostname>-hardware-configuration.nix
```

Replace the hardware UUID and kernel module references with the generated output.

### 5. Register in flake.nix

In `flake.nix`, add your user to `homeManagerModule`:

```nix
home-manager.users.<yourname> = import ./home/<yourname>.nix;
```

And add your host to `nixosConfigurations`:

```nix
<hostname> = mkHost ./hosts/<hostname>.nix;
```

### 6. Build

```bash
sudo nixos-rebuild switch --flake .#<hostname>
# or
make <hostname>
```

## Common Commands

| Command | Description |
|---------|-------------|
| `make <host>` | Rebuild and switch to a host config |
| `make update` | Update all flake inputs |
| `make clean` | Remove old generations and collect garbage |
| `nix build .#nixosConfigurations.<host>.config.home-manager.users.<user>.home.activationPackage` | Test HM build without switching |

## Hardware Notes

The `*-hardware-configuration.nix` files contain machine-specific UUIDs and kernel modules. They are **not reusable** across machines — always generate a fresh one with `nixos-generate-config` on your target hardware.
