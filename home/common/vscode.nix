{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };

  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  programs.vscode = {
    enable = true;
    package = unstable.vscode;
    userSettings = {
      "editor.renderWhitespace" = "trailing";
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "vs-kubernetes" = { };
      "eslint.validate" = [ "javascript" "typescript" ];
      "prettier.jsxSingleQuote" = true;
      "prettier.printWidth" = 100;
      "prettier.semi" = false;
      "prettier.singleQuote" = true;
      "prettier.singleAttributePerLine" = true;
      "prettier.tabWidth" = 4;
      "prettier.useTabs" = true;
      "prettier.ignorePath" = "~/.prettierignore";
      "explorer.confirmDragAndDrop" = false;
      "git.autofetch" = true;
      "debug.onTaskErrors" = "showErrors";
      "github.copilot.enable" = {
        "*" = true;
        "plaintext" = true;
        "markdown" = false;
        "scminput" = false;
        "yaml" = false;
      };
      "settingsSync.ignoredExtensions" = [ ];
      "workbench.colorTheme" = "Nord";
      "redhat.telemetry.enabled" = false;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = true;
      };
      "editor.inlineSuggest.enabled" = true;
      "editor.fontFamily" = "'Fira Code', 'Font Awesome 5', 'Font Awesome 5 Free Regular', 'Font Awesome 5 Free Solid', 'Font Awesome 5 Brands Regular', 'FiraCode Nerd Font Mono', CaskaydiaCoveNerdFont, 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "rnix-lsp";
      "[python]" = {
        "editor.formatOnType" = true;
      };
      "[go]" = {
        "editor.formatOnType" = true;
        "editor.defaultFormatter" = "golang.go";
      };
      "[helm]" = {
        "editor.formatOnSave" = false;
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[terraform]" = {
        "editor.defaultFormatter" = "hashicorp.terraform";
        "editor.formatOnSave" = true;
      };
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };
    };

    extensions = with pkgs; with vscode-extensions; [
      golang.go
      bbenoist.nix
      jnoortheen.nix-ide
      ms-dotnettools.csharp
      arcticicestudio.nord-visual-studio-code
      dbaeumer.vscode-eslint
      ms-azuretools.vscode-docker
      eamodio.gitlens
      esbenp.prettier-vscode
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "Orta";
        name = "vscode-twoslash-queries";
        version = "1.2.2";
        sha256 = "sha256-Gl2wmwZWnVE9LKdBu7JW8EbBNPRWV9yMoyI+J2NzXwY=";
      }
    ];
  };
}
