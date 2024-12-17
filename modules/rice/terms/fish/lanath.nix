{ ... }:
{
  programs.fish = {
    shellAliases = {
      k = "kubectl";
      d = "docker";
      g = "git";
      kssh = "kitten ssh";
    };
  };
}
