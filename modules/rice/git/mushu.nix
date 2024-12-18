{ ... }:
{
  programs.git = {
    enable = true;
    userName = "mushu";
    userEmail = "contact@marieforja.com";
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
    extraConfig = {
      pull.rebase = true;
    };
    signing = {
      signByDefault = false;
    };
  };
}
