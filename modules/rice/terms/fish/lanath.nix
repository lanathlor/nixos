{ ... }:
{
  programs.fish = {
    shellAliases = {
      k = "kubectl";
      d = "docker";
      dc = "docker compose";
      g = "git";
      kssh = "kitten ssh";
      bc = "pnpx better-commits";
    };
  };
}
