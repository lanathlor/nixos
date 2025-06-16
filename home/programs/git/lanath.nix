{ ... }:
{
  programs.git = {
    enable = true;
    userName = "lanath";
    userEmail = "valentin@viviersoft.com";
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
      signByDefault = true;
      key = "B3319E23B4F37099073FD764AC81A86C4854A64B";
    };
  };
}
