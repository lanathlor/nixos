{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    font-awesome
    font-awesome_5
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  fonts.fontDir.enable = true;

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
        sansSerif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
        monospace = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
      };
    };
  };
}
