{ ... }:
{
  programs.git = {
    enable = true;
    settings.user.name = "mushu";
    settings.user.email = "contact@marieforja.com";
    ignores = [
      "node_modules"
      "out"
      "*.log"
      "*.sqlite"
      "*.envrc"
      "*.pem"
      "*.key"
      "*.crt"
      "*.csr"
      "*.pfx"
      "*.cer"
      "*.jks"
      "*.keystore"
      "*~"
      ".direnv"
      ".envrc"
      "*tfstate*"
      ".terraform"
    ];
    settings = {
      pull.rebase = true;
    };
  };
}
