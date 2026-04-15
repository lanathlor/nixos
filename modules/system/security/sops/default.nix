{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    # Path to the encrypted secrets file in the repo
    defaultSopsFile = ../../../../secrets/secrets.yaml;

    # Where the age key is stored on the machine
    age.keyFile = "/var/lib/sops-nix/key.txt";

    # Secrets definitions - these get decrypted to /run/secrets/<name>
    secrets = {
      github_token = {
        owner = "root";
        group = "users";
        mode = "0440";
      };
      gitlab_token = {
        owner = "root";
        group = "users";
        mode = "0440";
      };
    };
  };
}
