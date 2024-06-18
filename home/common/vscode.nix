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
      "[go]" = {
        "editor.defaultFormatter" = "golang.go";
        "editor.formatOnType" = true;
      };
      "[helm]" = {
        "editor.formatOnSave" = false;
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };
      "[python]" = {
        "editor.formatOnType" = true;
      };
      "[terraform]" = {
        "editor.defaultFormatter" = "hashicorp.terraform";
        "editor.formatOnSave" = true;
      };
      "[shellscript]" = {
        "editor.defaultFormatter" = "foxundermoon.shell-format";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[dockerfile]" = {
        "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
      };
      "debug.onTaskErrors" = "showErrors";
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = "explicit";
      };
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.fontFamily" = "'Fira Code', 'Font Awesome 5', 'Font Awesome 5 Free Regular', 'Font Awesome 5 Free Solid', 'Font Awesome 5 Brands Regular', 'FiraCode Nerd Font Mono', CaskaydiaCoveNerdFont, 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.renderWhitespace" = "trailing";
      "eslint.validate" = [
        "javascript"
        "typescript"
      ];
      "explorer.confirmDragAndDrop" = false;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.enableCommitSigning" = true;
      "github.copilot.enable" = {
        "*" = true;
        "markdown" = true;
        "plaintext" = true;
        "scminput" = true;
        "yaml" = true;
      };
      "javascript.updateImportsOnFileMove.enabled" = "always";
      "nix.enableLanguageServer" = true;
      #"nix.serverPath" = "rnix-lsp";
      "prettier.ignorePath" = "~/.prettierignore";
      "prettier.jsxSingleQuote" = true;
      "prettier.printWidth" = 100;
      "prettier.semi" = false;
      "prettier.singleAttributePerLine" = true;
      "prettier.singleQuote" = true;
      "prettier.tabWidth" = 4;
      "prettier.useTabs" = true;
      "redhat.telemetry.enabled" = false;
      "settingsSync.ignoredExtensions" = [ ];
      "vs-kubernetes" = { };
      "workbench.colorTheme" = "Nord";
      "workbench.editor.enablePreview" = false;
      "excalidraw.theme" = "light";
      "explorer.confirmDelete" = false;
      "typescript.updateImportsOnFileMove.enabled"= "always";
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
      # curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/pomdtr/vsextensions/excalidraw-editor/3.7.3/vspackage | sha256sum
      {
        publisher = "pomdtr";
        name = "excalidraw-editor";
        version = "3.7.3";
        sha256 = "sha256-ORwyFwbKQgspI+uSTAcHqiM3vWQNHaRk2QD/4uRq+do=";
      }
    ];
  };
}
