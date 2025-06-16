{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      k = "kubectl";
      d = "docker";
      dc = "docker compose";
      g = "git";
      kssh = "kitten ssh";
      bc = "pnpx better-commits";
      bb = "npx --package=better-commits better-branch";
    };
  };
}
