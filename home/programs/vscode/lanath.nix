{ pkgs, pkgs-unstable, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    mutableExtensionsDir = false;

    profiles.default.extensions = with pkgs; with vscode-extensions; [
      golang.go
      ms-azuretools.vscode-docker
      bbenoist.nix
      jnoortheen.nix-ide
      ms-dotnettools.csharp
      dbaeumer.vscode-eslint
      ms-azuretools.vscode-docker
      eamodio.gitlens
      esbenp.prettier-vscode
      yzhang.markdown-all-in-one
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
