# SSH Public Keys

Place your SSH public keys in the `keys/` directory (one level up from here).

The `keys/` directory is gitignored — each deployment has its own keys.

## Setup

```bash
mkdir -p keys
cp ~/.ssh/id_ed25519.pub keys/mykey.pub
```

Then reference the filename in `local.nix`:

```nix
users.user.sshKeyFiles = [ "mykey.pub" ];
```

These keys are used for:
- SSH login authorization (`openssh.authorizedKeys.keyFiles`)
- Root SSH access
