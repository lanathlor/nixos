# NixOS Configuration

Personal NixOS flake for two users across multiple machines, built with Home Manager.

## Secrets Management

This repository uses [sops-nix](https://github.com/Mic92/sops-nix) to manage sensitive information like API keys and tokens.

### Initial Setup

1. **Generate an age key** (one-time per machine):
   ```bash
   sudo mkdir -p /var/lib/sops-nix
   sudo age-keygen -o /var/lib/sops-nix/key.txt
   sudo chmod 600 /var/lib/sops-nix/key.txt
   ```

2. **Get your public key**:
   ```bash
   sudo age-keygen -y /var/lib/sops-nix/key.txt
   # Output: age1xxxxxx...
   ```

3. **Update `.sops.yaml`** with your public key:
   ```yaml
   creation_rules:
     - path_regex: secrets/.*\.yaml$
       age: >-
         age1your-public-key-here
   ```

### Creating Secrets

1. **Create the secrets file** from the example:
   ```bash
   cp secrets/secrets.yaml.example secrets/secrets.yaml
   ```

2. **Encrypt with sops**:
   ```bash
   sops -e -i secrets/secrets.yaml
   ```

3. **Edit encrypted secrets** (sops decrypts in-place):
   ```bash
   sops secrets/secrets.yaml
   ```

### Secrets File Format

```yaml
github_token: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
gitlab_token: glpat-xxxxxxxxxxxxxxxxxxxx
```

### How It Works

- Secrets are encrypted in `secrets/secrets.yaml` and committed to git
- On NixOS rebuild, sops-nix decrypts them to `/run/secrets/<secret_name>`
- The age private key at `/var/lib/sops-nix/key.txt` is used for decryption
- Secrets are only readable by root and the `users` group

### Adding New Secrets

1. Add the key to `secrets/secrets.yaml`:
   ```bash
   sops secrets/secrets.yaml
   # Add: my_new_secret: "value"
   ```

2. Define the secret in `modules/system/security/sops/default.nix`:
   ```nix
   sops.secrets.my_new_secret = {
     owner = "root";
     group = "users";
     mode = "0440";
   };
   ```

3. Rebuild: `sudo nixos-rebuild switch --flake .#<host>`

The secret will be available at `/run/secrets/my_new_secret`.


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
