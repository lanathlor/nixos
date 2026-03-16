{ pkgs, lib, ... }:
let
  nord        = import ./nordic/meta.nix     { inherit pkgs; };
  catppuccin  = import ./catppuccin/meta.nix { inherit pkgs; };
  dracula     = import ./dracula/meta.nix    { inherit pkgs; };
  gruvbox     = import ./gruvbox/meta.nix    { inherit pkgs; };
  tokyonight  = import ./tokyonight/meta.nix { inherit pkgs; };
  everforest  = import ./everforest/meta.nix { inherit pkgs; };
  rosepine    = import ./rosepine/meta.nix   { inherit pkgs; };
  onedark     = import ./onedark/meta.nix    { inherit pkgs; };
  kanagawa    = import ./kanagawa/meta.nix   { inherit pkgs; };

  allThemes = map withAssets [ nord catppuccin dracula gruvbox tokyonight everforest rosepine onedark kanagawa ];

  rofiTheme = pkgs.writeText "theme-switcher.rasi" ''
    * { bg: #2e3440; bg2: #3b4252; accent: #5e81ac; fg: #eceff4; }
    window      { background-color: @bg; border-radius: 12px; width: 1400px; height: 940px; }
    mainbox     { background-color: transparent; padding: 16px; }
    inputbar    { background-color: @bg2; text-color: @fg; border-radius: 8px;
                  padding: 8px 12px; margin: 0 0 16px; }
    listview    { background-color: transparent; columns: 3; lines: 3; spacing: 12px; }
    element     { background-color: @bg2; border-radius: 8px; padding: 8px;
                  orientation: vertical; }
    element selected { background-color: @accent; }
    element-icon { size: 390px; border-radius: 6px; }
    element-text { background-color: transparent; text-color: @fg;
                   horizontal-align: 0.5; padding: 8px 0 0; }
  '';

  mkRofiTheme = { bg, bg2, fg, selected, urgent }: pkgs.writeText "rofi-theme.rasi" ''
    * {
        bg: ${bg}; bg2: ${bg2}a0; fg: ${fg}; selected: ${selected}; urgent: ${urgent};
        foreground: @fg; background-color: transparent; background: @bg2;
    }
    window { transparency: "real"; location: center; anchor: center;
             width: 900px; border-radius: 24px; background-color: @background; }
    mainbox { spacing: 0px; background-color: transparent; orientation: horizontal;
              children: [ "imagebox", "listbox" ]; }
    imagebox { padding: 30px; background-color: transparent;
               background-image: url("~/.wallpapers/wallpaper.png", height);
               orientation: vertical; children: [ "inputbar", "dummy", "mode-switcher" ]; }
    listbox { spacing: 20px; padding: 20px; background-color: transparent;
              orientation: vertical; children: [ "message", "listview" ]; }
    inputbar { spacing: 10px; padding: 15px; border-radius: 24px;
               background-color: @bg; text-color: @foreground;
               children: [ "textbox-prompt-colon", "entry" ]; }
    textbox-prompt-colon { expand: false; str: " ";
                           background-color: inherit; text-color: inherit; }
    entry { background-color: inherit; text-color: inherit; cursor: text;
            placeholder: "Search"; placeholder-color: inherit; }
    listview { columns: 2; lines: 8; cycle: true; dynamic: true; scrollbar: false;
               spacing: 10px; background-color: transparent; text-color: @foreground; }
    mode-switcher { spacing: 20px; background-color: transparent; text-color: @foreground; }
    button { padding: 15px; border-radius: 24px; background-color: @background;
             text-color: inherit; cursor: pointer; }
    button selected { background-color: @selected; text-color: @foreground; }
    element { spacing: 15px; padding: 8px; border-radius: 24px;
              background-color: transparent; text-color: @foreground; cursor: pointer; }
    element normal.normal    { background-color: inherit;   text-color: inherit; }
    element normal.urgent    { background-color: @urgent;   text-color: @foreground; }
    element normal.active    { background-color: @selected; text-color: @foreground; }
    element alternate.normal { background-color: inherit;   text-color: inherit; }
    element alternate.urgent { background-color: @urgent;   text-color: @foreground; }
    element alternate.active { background-color: @selected; text-color: @foreground; }
    element selected.normal  { background-color: @selected; text-color: @foreground; }
    element selected.urgent  { background-color: @urgent;   text-color: @foreground; }
    element selected.active  { background-color: @urgent;   text-color: @foreground; }
    element-icon { background-color: transparent; text-color: inherit;
                   size: 32px; cursor: inherit; }
    element-text { background-color: transparent; text-color: inherit;
                   cursor: inherit; vertical-align: 0.5; horizontal-align: 0.0; }
    message { background-color: transparent; }
    textbox { padding: 15px; border-radius: 24px; background-color: @bg;
              text-color: @foreground; vertical-align: 0.5; horizontal-align: 0.0; }
    error-message { padding: 16px; border-radius: 24px;
                    background-color: @background; text-color: @foreground; }
  '';

  mkDunstConf = { bg2, fg, accent, red }: pkgs.writeText "dunstrc" ''
    [global]
        font = FiraCode Nerd Font Mono 11
        markup = full
        format = <b>%s</b>\n%b
        sort = no
        indicate_hidden = yes
        alignment = left
        vertical_alignment = center
        show_age_threshold = 60
        word_wrap = yes
        ignore_newline = no
        stack_duplicates = yes
        hide_duplicate_count = no
        width = (200, 420)
        height = (0, 200)
        origin = bottom-right
        offset = 12x12
        transparency = 0
        idle_threshold = 120
        monitor = 0
        follow = keyboard
        sticky_history = yes
        history_length = 20
        show_indicators = no
        line_height = 2
        separator_height = 0
        padding = 14
        horizontal_padding = 18
        text_icon_padding = 12
        separator_color = frame
        icon_position = left
        min_icon_size = 32
        max_icon_size = 64
        corner_radius = 12
        progress_bar = true
        progress_bar_height = 6
        progress_bar_corner_radius = 3
        gap_size = 8
        frame_width = 1

    [urgency_low]
        frame_color = "${accent}77"
        background = "${bg2}ee"
        foreground = "${fg}"
        timeout = 4

    [urgency_normal]
        frame_color = "${accent}"
        background = "${bg2}ee"
        foreground = "${fg}"
        timeout = 4

    [urgency_critical]
        frame_color = "${red}"
        background = "${bg2}ee"
        foreground = "${fg}"
        timeout = 0
  '';

  mkTmuxConf = { bg, fg, accent, bg2, fgOnAccent }: pkgs.writeText "tmux-colors" ''
    set -g status-style    "bg=${bg},fg=${fg}"
    set -g status-interval 2
    set -g status-left        "#[bg=${bg},fg=${accent}]#[bg=${accent},fg=${fgOnAccent},bold] #S #[bg=${bg},fg=${accent}] "
    set -g status-left-length 30
    set -g status-right        " #[bg=${bg},fg=${accent}]#[bg=${accent},fg=${fgOnAccent}]  %H:%M    %d %b #[bg=${bg},fg=${accent}]"
    set -g status-right-length 40
    set -g window-status-style         "bg=${bg}"
    set -g window-status-current-style "bg=${bg}"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=${bg},fg=${bg2}]#[bg=${bg2},fg=${fg}] #I  #W #[bg=${bg},fg=${bg2}]"
    set -g window-status-current-format \
      "#[bg=${bg},fg=${accent}]#[bg=${accent},fg=${fgOnAccent},bold] #I  #W #[bg=${bg},fg=${accent}]"
    set -g pane-border-style        "fg=${bg2}"
    set -g pane-active-border-style "fg=${accent}"
    set -g message-style            "bg=${bg2},fg=${fg}"
    set -g message-command-style    "bg=${bg2},fg=${fg}"
    set -g mode-style               "bg=${accent},fg=${fgOnAccent}"
  '';

  mkUserChromeCss = { bg, fg, accent, bg2, fgOnAccent }: pkgs.writeText "userChrome.css" ''
    /* ── CSS custom properties ──────────────────────────────────────────── */
    :root, :root:-moz-lwtheme {
      --toolbar-bgcolor:                  ${bg}     !important;
      --toolbar-color:                    ${fg}     !important;
      --lwt-accent-color:                 ${bg}     !important;
      --lwt-text-color:                   ${fg}     !important;
      --urlbar-box-bgcolor:               ${bg2}    !important;
      --urlbar-box-focus-bgcolor:         ${bg2}    !important;
      --urlbar-box-hover-bgcolor:         ${bg2}    !important;
      --urlbar-box-active-bgcolor:        ${bg2}    !important;
      --urlbar-box-text-color:            ${fg}     !important;
      --tab-selected-bgcolor:             ${bg2}    !important;
      --tab-selected-color:               ${fg}     !important;
      --tab-loading-fill:                 ${accent} !important;
      --toolbarbutton-hover-background:   ${bg2}    !important;
      --toolbarbutton-active-background:  ${accent} !important;
      --tabs-border-color:                ${accent} !important;
      --panel-background:                 ${bg}     !important;
      --panel-color:                      ${fg}     !important;
      --arrowpanel-background:            ${bg}     !important;
      --arrowpanel-color:                 ${fg}     !important;
      --arrowpanel-border-color:          ${bg2}    !important;
      /* Zen-specific */
      --zen-primary-color:                ${accent} !important;
      --zen-colors-primary:               ${bg}     !important;
      --zen-colors-secondary:             ${bg2}    !important;
      --zen-colors-tertiary:              ${bg2}    !important;
      --zen-colors-border:                ${bg2}    !important;
    }

    /* ── Toolbars ───────────────────────────────────────────────────────── */
    #nav-bar, #toolbar-menubar, #TabsToolbar, #PersonalToolbar,
    #navigator-toolbox {
      background-color: ${bg} !important;
      color:            ${fg} !important;
    }

    /* ── URL bar input field ────────────────────────────────────────────── */
    #urlbar-background {
      background-color: ${bg2} !important;
    }
    #urlbar[focused="true"] > #urlbar-background {
      background-color: ${bg2} !important;
    }
    #urlbar-input, #urlbar-label {
      color: ${fg} !important;
    }

    /* ── URL bar results dropdown (inline div, not a panel) ─────────────── */
    .urlbarView {
      background-color: ${bg}  !important;
      color:            ${fg}  !important;
      border-color:     ${bg2} !important;
    }
    .urlbarView-body-inner, .urlbarView-results {
      background-color: ${bg} !important;
    }
    .urlbarView-row {
      color: ${fg} !important;
    }
    .urlbarView-row:hover,
    .urlbarView-row[selected="true"],
    .urlbarView-row[selected] {
      background-color: ${bg2} !important;
      color:            ${fg}  !important;
    }
    .urlbarView-title, .urlbarView-secondary, .urlbarView-url {
      color: ${fg} !important;
    }
    .urlbarView-url {
      color: ${accent} !important;
    }

    /* ── Tabs ───────────────────────────────────────────────────────────── */
    .tabbrowser-tab[selected] .tab-background {
      background-color: ${bg2} !important;
    }
    .tab-label, .tab-text {
      color: ${fg} !important;
    }

    /* ── Panels, menus, popups ──────────────────────────────────────────── */
    .panel-arrowcontent, menupopup, panel {
      background-color: ${bg} !important;
      color:            ${fg} !important;
    }
    menuitem, menu, menuitem > *, menu > * {
      color: ${fg} !important;
    }
    menuitem:hover, menu[_moz-menuactive="true"] {
      background-color: ${bg2} !important;
      color:            ${fg}  !important;
    }
  '';

  mkGtkSettings = { theme, icons }: pkgs.writeText "gtk-settings.ini" ''
    [Settings]
    gtk-theme-name=${theme}
    gtk-icon-theme-name=${icons}
    gtk-font-name=Noto Sans 10
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark-theme=1
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintfull
    gtk-xft-rgba=rgb
  '';

  withAssets = t: t // {
    rofiTheme   = mkRofiTheme t.rofiColors;
    dunstConf   = mkDunstConf t.dunstColors;
    tmuxConf    = mkTmuxConf  t.tmuxColors;
    gtkSettings = mkGtkSettings { theme = t.gtkTheme; icons = t.gtkIcons; };
    firefoxCss  = mkUserChromeCss t.tmuxColors;
  };

  themeEntry   = t: ''printf '%s\x00icon\x1f%s\n' "${t.name}" "${t.previewPng}"'';
  themeEntries = lib.concatStringsSep "\n" (map themeEntry allThemes);

  applyCase = t: ''
    "${t.name}")
      swww img "${t.wallpaper}"
      mkdir -p "$HOME/.wallpapers"
      ln -sf "${t.wallpaper}"    "$HOME/.wallpapers/wallpaper.png"
      ln -sf "${t.waybarCss}"     "$HOME/.config/waybar/style.css"
      ln -sf "${t.starshipToml}"  "$HOME/.config/starship.toml"
      ln -sf "${t.rofiTheme}"     "$HOME/.config/rofi/theme.rasi"
      mkdir -p "$HOME/.config/kitty" "$HOME/.config/dunst" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
      ln -sf "${t.kittyColors}"   "$HOME/.config/kitty/current-theme.conf"
      ln -sf "${t.dunstConf}"     "$HOME/.config/dunst/dunstrc"
      ln -sf "${t.gtkSettings}"   "$HOME/.config/gtk-3.0/settings.ini"
      ln -sf "${t.gtkSettings}"   "$HOME/.config/gtk-4.0/settings.ini"
      dunstctl reload 2>/dev/null || systemctl --user restart dunst 2>/dev/null || true
      pkill -SIGUSR2 waybar || true
      _uid=$(id -u)
      while IFS= read -r _tsock; do
        tmux -S "$_tsock" source-file "${t.tmuxConf}" 2>/dev/null || true
      done < <(find /tmp /run/user/"$_uid" -maxdepth 3 -path "*/tmux-$_uid/*" -type s 2>/dev/null)
      for _sock in /tmp/kitty-*; do
        [ -S "$_sock" ] && kitty @ --to "unix:$_sock" \
          set-colors -a -c "${t.kittyColors}" 2>/dev/null || true
      done
      for _sock in "/run/user/$(id -u)/nvim."*; do
        [ -S "$_sock" ] && nvim --server "$_sock" \
          --remote-send ":colorscheme ${t.neovimColorscheme}<CR>" 2>/dev/null || true
      done
      dconf write /org/gnome/desktop/interface/gtk-theme  "'${t.gtkTheme}'"  || true
      dconf write /org/gnome/desktop/interface/icon-theme "'${t.gtkIcons}'" || true
      for _zp in "$HOME/.zen"/*/ "$HOME/.mozilla/firefox"/*/; do
        [ -f "$_zp/cert9.db" ] || continue
        mkdir -p "$_zp/chrome"
        ln -sf "${t.firefoxCss}" "$_zp/chrome/userChrome.css"
      done
      printf '%s' "${t.name}"              > "$HOME/.cache/current-theme"
      printf '%s' "${t.neovimColorscheme}" > "$HOME/.cache/nvim-colorscheme"
      notify-send "󰏘 Theme" "Switched to ${t.name}" --icon=preferences-desktop-theme
    ;;
  '';

  themeBlock  = lib.concatStrings (map applyCase allThemes);

  nordFull = withAssets nord;
in
{
  # Install all theme neovim plugins so :colorscheme works after live switch
  programs.neovim.plugins = map (t: t.neovimPlugin) allThemes;

  # Remove files that HM now owns (e.g. rofi/config.rasi) but were previously
  # managed by theme-switch. Must run before writeBoundary so HM can write freely.
  # Only rofi/config.rasi needs clearing: it was previously owned by theme-switch,
  # now HM owns it. gtk settings.ini was previously HM-managed and is now unmanaged
  # (HM auto-cleans it on first rebuild; no need to clear it here or it resets on every rebuild).
  home.activation.clearThemeMigration = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "$HOME/.config/rofi/config.rasi"
  '';

  # On first activation (or after a theme-switch reset), create initial symlinks
  # pointing to Nord. If the file is already a symlink (set by theme-switch), leave it alone.
  home.activation.initTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/waybar" "$HOME/.config/rofi" "$HOME/.config/dunst" \
             "$HOME/.config/kitty" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.wallpapers"
    [ -L "$HOME/.config/waybar/style.css"            ] || ln -sf "${nordFull.waybarCss}"    "$HOME/.config/waybar/style.css"
    [ -L "$HOME/.config/starship.toml"               ] || ln -sf "${nordFull.starshipToml}" "$HOME/.config/starship.toml"
    [ -L "$HOME/.config/rofi/theme.rasi"             ] || ln -sf "${nordFull.rofiTheme}"    "$HOME/.config/rofi/theme.rasi"
    [ -L "$HOME/.config/dunst/dunstrc"               ] || ln -sf "${nordFull.dunstConf}"    "$HOME/.config/dunst/dunstrc"
    [ -L "$HOME/.config/kitty/current-theme.conf"    ] || ln -sf "${nordFull.kittyColors}"  "$HOME/.config/kitty/current-theme.conf"
    [ -L "$HOME/.config/gtk-3.0/settings.ini"        ] || ln -sf "${nordFull.gtkSettings}"  "$HOME/.config/gtk-3.0/settings.ini"
    [ -L "$HOME/.config/gtk-4.0/settings.ini"        ] || ln -sf "${nordFull.gtkSettings}"  "$HOME/.config/gtk-4.0/settings.ini"
    [ -L "$HOME/.wallpapers/wallpaper.png"           ] || ln -sf "${nordFull.wallpaper}"    "$HOME/.wallpapers/wallpaper.png"
    for _zp in "$HOME/.zen"/*/ "$HOME/.mozilla/firefox"/*/; do
      [ -f "$_zp/cert9.db" ] || continue
      mkdir -p "$_zp/chrome"
      [ -L "$_zp/chrome/userChrome.css" ] || ln -sf "${nordFull.firefoxCss}" "$_zp/chrome/userChrome.css"
    done
  '';

  home.packages = with pkgs; [
    # GTK theme packages for all themes (installed so theme-switch can apply them)
    nordic
    papirus-icon-theme
    (catppuccin-gtk.override { variant = "mocha"; accents = [ "mauve" ]; })
    dracula-theme
    everforest-gtk-theme
    rose-pine-gtk-theme
  ] ++ [
    (pkgs.writeShellApplication {
      name = "theme-switch";
      runtimeInputs = with pkgs; [ swww tmux glib dconf libnotify procps coreutils ];
      # kitty, nvim, rofi come from home-manager; bare names work fine
      text = ''
        SELECTED=$(
          {
            ${themeEntries}
          } | rofi -dmenu -i -show-icons -p "󰏘  Theme" -theme "${rofiTheme}"
        ) || exit 0
        case "$SELECTED" in
          ${themeBlock}
          *) exit 1 ;;
        esac
      '';
    })
  ];
}
