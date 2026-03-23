# Base VSCode settings shared across all themes.
# workbench.colorTheme is injected per-theme by registry.nix.
{
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
  "[markdown]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.formatOnSave" = true;
    "editor.wordWrap" = "on";
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
  "remote.SSH.configFile" = "~/.ssh/vscode_hosts";
  "vs-kubernetes" = { };
  "workbench.editor.enablePreview" = false;
  "excalidraw.theme" = "light";
  "explorer.confirmDelete" = false;
  "typescript.updateImportsOnFileMove.enabled" = "always";
}
