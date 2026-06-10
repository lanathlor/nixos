{ ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -gx GPG_TTY (tty)
      gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
    '';
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
