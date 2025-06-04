{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    font-awesome
    font-awesome_5
    proggyfonts
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.caskaydia-mono
    nerd-fonts.noto
  ];

  fonts.fontDir.enable = true;

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" "Fira Code" "Fira Code Symbol" ];
        sansSerif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" "Fira Code" "Fira Code Symbol" ];
        monospace = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" "Fira Code" "Fira Code Symbol" ];
      };
    };
  };
}
