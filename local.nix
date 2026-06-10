# local.nix — your personal overrides (only set what differs from config-defaults.nix)
# After editing, run: git update-index --skip-worktree local.nix
# This prevents accidentally committing your personal data.
#
# Setup checklist:
#   - Place your SSH public keys in keys/ (see keys.example/README.md)
#   - Copy .sops.example.yaml to .sops.yaml and set your age public key
#   - Generate hardware config: nixos-generate-config --show-hardware-config
{
  # hostName = "my-machine";
  # githubUser = "my-username";
  # localDomain = "local.mydomain.com";

  # weather = {
  #   apiKey = "your-key";
  #   appId = "your-key";
  #   lat = "48.85";
  #   lon = "2.35";
  # };

  # llm.enable = true;
  # qemu.enable = true;
  # vscodeServer.enable = true;

  # users.lanath.git.personalEmail = "me@example.com";
}
