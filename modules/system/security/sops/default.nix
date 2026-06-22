{ inputs, config, localConfig, lib, ... }:
let
  # Readable by the user (group "users") — consumed at runtime, e.g. the
  # waybar weather script reads /run/secrets/weather_appid.
  userReadable = {
    owner = "root";
    group = "users";
    mode = "0440";
  };
  # One password hash secret per configured user. neededForUsers makes
  # sops-nix decrypt it early (to /run/secrets-for-users) so it is
  # available when accounts are created — required by hashedPasswordFile.
  passwordSecrets = lib.mapAttrs'
    (name: _: lib.nameValuePair "${name}_password" { neededForUsers = true; })
    localConfig.users;
in
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
      github_token = userReadable;
      gitlab_token = userReadable;
      weather_appid = userReadable;
    } // passwordSecrets;
  };
}
