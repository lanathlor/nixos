{ pkgs, pkgs-unstable, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;

    profiles.default.userSettings = {
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
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };
      "[python]" = {
        "editor.formatOnType" = true;
        "editor.defaultFormatter" = "ms-python.black-formatter";
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
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[dockerfile]" = {
        "editor.defaultFormatter" = "ms-azuretools.vscode-docker";
      };
      "debug.onTaskErrors" = "showErrors";
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = "explicit";
      };
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
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
        };
      };
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
      "typescript.updateImportsOnFileMove.enabled" = "always";
    };

    profiles.default.extensions = with pkgs; with vscode-extensions; [
      golang.go
      ms-azuretools.vscode-docker
      bbenoist.nix
      jnoortheen.nix-ide
      ms-dotnettools.csharp
      arcticicestudio.nord-visual-studio-code
      dbaeumer.vscode-eslint
      ms-azuretools.vscode-docker
      eamodio.gitlens
      esbenp.prettier-vscode
      gitlab.gitlab-workflow
      github.copilot
      vscode-extensions.github.copilot-chat
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "Orta";
        name = "vscode-twoslash-queries";
        version = "1.2.2";
        sha256 = "sha256-Gl2wmwZWnVE9LKdBu7JW8EbBNPRWV9yMoyI+J2NzXwY=";
      }
      {
        publisher = "pomdtr";
        name = "excalidraw-editor";
        version = "3.7.3";
        sha256 = "sha256-ORwyFwbKQgspI+uSTAcHqiM3vWQNHaRk2QD/4uRq+do=";
      }
      # curl https://marketplace.visualstudio.com/_apis/public/gallery/publishers/4ops/vsextensions/terraform/0.2.5/vspackage | sha256sum
      {
        publisher = "hashicorp";
        name = "terraform";
        version = "2.34.2";
        sha256 = "sha256-lU1SrAPDCCSanJaB0xRVFWmi9a1J4Btj9oORatToM6w=";
      }
    ];
  };
}
