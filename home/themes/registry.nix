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

  mkSwitcherTheme = { bg, bg2, fg, selected, urgent }: pkgs.writeText "theme-switcher.rasi" ''
    * { bg: ${bg}; bg2: ${bg2}; accent: ${selected}; fg: ${fg}; }
    window      { background-color: @bg; border-radius: 12px; width: 1300px; }
    mainbox     { background-color: transparent; padding: 16px;
                  children: [ "inputbar", "listview", "message" ]; }
    inputbar    { background-color: @bg2; text-color: @fg; border-radius: 8px;
                  padding: 8px 12px; margin: 0 0 12px; }
    listview    { background-color: transparent; columns: 3; lines: 2; spacing: 8px;
                  fixed-height: false; }
    element     { background-color: @bg2; border-radius: 8px; padding: 4px;
                  orientation: vertical; }
    element selected { background-color: @accent; }
    element-icon { size: 400px; border-radius: 6px; background-color: @bg2; }
    element-text { background-color: transparent; text-color: @fg;
                   horizontal-align: 0.5; padding: 6px 0 0; }
    message     { padding: 10px 0 0; background-color: transparent; }
    textbox     { background-color: transparent; text-color: @fg;
                  horizontal-align: 0.5; padding: 4px; }
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

  baseVscodeSettings = import ../programs/vscode/settings.nix;

  mkVscodeSettings = themeName: pkgs.writeText "vscode-settings.json"
    (builtins.toJSON (baseVscodeSettings // { "workbench.colorTheme" = themeName; }));

  mkSwaylockConf = { bg, bg2, fg, accent, clear, wrong, green, purple, yellow, orange }:
    let s = c: builtins.substring 1 6 c;  # strip "#" – swaylock wants raw hex
    in pkgs.writeText "swaylock-config" ''
    ignore-empty-password
    show-failed-attempts
    show-keyboard-layout
    line-uses-ring
    color=${s bg}
    indicator-radius=100
    indicator-thickness=10
    inside-color=${s bg}ff
    inside-clear-color=${s clear}ff
    inside-ver-color=${s accent}ff
    inside-wrong-color=${s wrong}ff
    key-hl-color=${s green}ff
    bs-hl-color=${s purple}ff
    caps-lock-key-hl-color=${s yellow}ff
    caps-lock-bs-hl-color=${s orange}ff
    layout-bg-color=${s bg}ff
    ring-color=${s bg2}ff
    ring-clear-color=${s clear}ff
    ring-ver-color=${s accent}ff
    ring-wrong-color=${s wrong}ff
    separator-color=${s bg2}ff
    text-color=${s fg}ff
    text-clear-color=${s bg2}ff
    text-ver-color=${s bg2}ff
    text-wrong-color=${s bg2}ff
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

  # Qt5 palette for qt5ct – maps theme colors to QPalette roles (21 colors).
  # Format: #AARRGGBB per qt5ct convention.
  mkQt5ctColors = { bg, fg, accent, bg2, fgOnAccent }:
    let
      o = c: "#ff" + builtins.substring 1 6 c;  # opaque
      t = c: "#80" + builtins.substring 1 6 c;  # semi-transparent
      d = c: "#40" + builtins.substring 1 6 c;  # dim
      #        WinText  Button   Light    MidLt    Dark     Mid      Text     Bright   BtnText  Base     Window   Shadow   Hilite   HiText   Link     LinkVis  AltBase  NoRole   TipBase  TipText  Placeh
      active   = builtins.concatStringsSep ", " [ (o fg) (o bg2) (o bg2) (o bg2) (o bg) (o bg2) (o fg) (o fgOnAccent) (o fg) (o bg) (o bg) (o bg) (o accent) (o fgOnAccent) (o accent) (o accent) (o bg2) (o bg) (o bg2) (o fg) (t fg) ];
      inactive = builtins.concatStringsSep ", " [ (o fg) (o bg2) (o bg2) (o bg2) (o bg) (o bg2) (o fg) (o fgOnAccent) (o fg) (o bg) (o bg) (o bg) (t accent) (o fgOnAccent) (o accent) (o accent) (o bg2) (o bg) (o bg2) (o fg) (t fg) ];
      disabled = builtins.concatStringsSep ", " [ (t fg) (o bg2) (o bg2) (o bg2) (o bg) (o bg2) (t fg) (o fgOnAccent) (t fg) (o bg) (o bg) (o bg) (o bg2) (t fg) (t accent) (t accent) (o bg2) (o bg) (o bg2) (t fg) (d fg) ];
    in pkgs.writeText "qt5ct-colors.conf" ''
      [ColorScheme]
      active_colors=${active}
      inactive_colors=${inactive}
      disabled_colors=${disabled}
    '';

  # Custom QSS stylesheet for Qt5 apps – overrides built-in application styles.
  # Loaded by qt5ct AFTER the app's own setStyleSheet(), so these rules win.
  mkQt5ctQss = { bg, fg, accent, bg2, fgOnAccent }: pkgs.writeText "qt5ct-theme.qss" ''
    QMainWindow, QDialog, QWidget { background-color: ${bg}; color: ${fg}; }
    QLabel { color: ${fg}; background-color: transparent; }

    QMenuBar { background-color: ${bg}; color: ${fg}; border: none; }
    QMenuBar::item:selected { background-color: ${bg2}; }
    QMenu { background-color: ${bg}; color: ${fg}; border: 1px solid ${bg2}; }
    QMenu::item:selected { background-color: ${accent}; color: ${fgOnAccent}; }
    QMenu::separator { background-color: ${bg2}; height: 1px; margin: 4px 8px; }

    QToolBar { background-color: ${bg}; border: none; spacing: 4px; padding: 4px; }
    QToolButton { background-color: transparent; color: ${fg}; border: none;
                  border-radius: 4px; padding: 6px; margin: 1px; }
    QToolButton:hover { background-color: ${bg2}; }
    QToolButton:pressed, QToolButton:checked { background-color: ${accent}; color: ${fgOnAccent}; }

    QTreeView, QTableView, QListView, QTreeWidget, QListWidget {
      background-color: ${bg}; alternate-background-color: ${bg2}; color: ${fg};
      selection-background-color: ${accent}; selection-color: ${fgOnAccent};
      border: 1px solid ${bg2}; outline: none;
    }
    QTreeView::item, QListView::item, QListWidget::item {
      padding: 4px 2px; min-height: 22px;
    }
    QTableView::item { padding: 6px 8px; }
    QTreeView::branch { background-color: ${bg}; }
    QTreeView::branch:selected { background-color: ${accent}; }
    QTreeView::item:selected, QTableView::item:selected, QListView::item:selected {
      background-color: ${accent}; color: ${fgOnAccent};
    }
    QTreeView::item:hover, QTableView::item:hover, QListView::item:hover {
      background-color: ${bg2};
    }
    QHeaderView::section { background-color: ${bg2}; color: ${fg};
                           border: 1px solid ${bg}; padding: 6px 10px; }

    QLineEdit, QTextEdit, QPlainTextEdit, QSpinBox, QDoubleSpinBox {
      background-color: ${bg2}; color: ${fg}; border: 1px solid ${bg2};
      border-radius: 4px; padding: 6px 8px; selection-background-color: ${accent};
      selection-color: ${fgOnAccent};
    }
    QLineEdit:focus, QTextEdit:focus, QPlainTextEdit:focus {
      border-color: ${accent};
    }
    QComboBox { background-color: ${bg2}; color: ${fg}; border: 1px solid ${bg2};
                border-radius: 4px; padding: 6px 10px; }
    QComboBox:hover { border-color: ${accent}; }
    QComboBox::drop-down { border: none; }
    QComboBox QAbstractItemView { background-color: ${bg}; color: ${fg};
                                  selection-background-color: ${accent};
                                  selection-color: ${fgOnAccent}; }
    QComboBox QAbstractItemView::item { padding: 6px 8px; min-height: 22px; }

    QPushButton { background-color: ${bg2}; color: ${fg}; border: 1px solid ${bg2};
                  border-radius: 4px; padding: 8px 20px; }
    QPushButton:hover { background-color: ${accent}; color: ${fgOnAccent};
                        border-color: ${accent}; }
    QPushButton:pressed { background-color: ${accent}; }
    QPushButton:default { border-color: ${accent}; }
    QPushButton:disabled { color: ${bg2}; }

    QTabWidget::pane { border: 1px solid ${bg2}; background-color: ${bg}; }
    QTabBar::tab { background-color: ${bg2}; color: ${fg}; padding: 8px 18px;
                   border: none; margin-right: 2px; }
    QTabBar::tab:selected { background-color: ${accent}; color: ${fgOnAccent}; }
    QTabBar::tab:hover:!selected { background-color: ${bg2}; }

    QMenuBar { padding: 2px; }
    QMenuBar::item { padding: 6px 10px; }
    QMenu::item { padding: 6px 24px 6px 12px; }

    QStatusBar { background-color: ${bg}; color: ${fg}; padding: 2px; }
    QStatusBar::item { border: none; }

    QScrollBar:vertical { background-color: ${bg}; width: 10px; margin: 0; }
    QScrollBar:horizontal { background-color: ${bg}; height: 10px; margin: 0; }
    QScrollBar::handle:vertical, QScrollBar::handle:horizontal {
      background-color: ${bg2}; border-radius: 4px; min-height: 20px; min-width: 20px;
    }
    QScrollBar::handle:vertical:hover, QScrollBar::handle:horizontal:hover {
      background-color: ${accent};
    }
    QScrollBar::add-line, QScrollBar::sub-line { height: 0; width: 0; }
    QScrollBar::add-page, QScrollBar::sub-page { background: none; }

    QToolTip { background-color: ${bg2}; color: ${fg}; border: 1px solid ${accent};
               padding: 6px; }
    QGroupBox { border: 1px solid ${bg2}; border-radius: 4px; margin-top: 10px;
                padding: 20px 8px 8px 8px; color: ${fg}; }
    QGroupBox::title { subcontrol-origin: margin; left: 10px; padding: 0 6px;
                       color: ${accent}; }

    QCheckBox, QRadioButton { color: ${fg}; spacing: 8px; padding: 4px; }
    QCheckBox::indicator, QRadioButton::indicator { width: 18px; height: 18px; }

    QProgressBar { background-color: ${bg2}; border-radius: 4px; text-align: center;
                   color: ${fg}; min-height: 20px; }
    QProgressBar::chunk { background-color: ${accent}; border-radius: 4px; }

    QSplitter::handle { background-color: ${bg2}; }
    QFrame[frameShape="4"], QFrame[frameShape="5"] { color: ${bg2}; }
  '';

  # GTK4 CSS for regreet greeter – overlays on top of the base Adwaita-dark GTK theme.
  # Uses semi-transparent backgrounds so the wallpaper shows through.
  mkRegreetCss = { bg, fg, accent, bg2, fgOnAccent }: pkgs.writeText "regreet-theme.css" ''
    window {
      background-color: rgba(0, 0, 0, 0.85);
    }

    entry {
      background-color: ${bg2};
      color: ${fg};
      border: 2px solid ${bg2};
      border-radius: 8px;
      padding: 8px 12px;
    }

    entry:focus {
      border-color: ${accent};
    }

    button {
      background-color: ${bg2};
      color: ${fg};
      border: none;
      border-radius: 8px;
      padding: 8px 16px;
    }

    button:hover {
      background-color: ${accent};
      color: ${fgOnAccent};
    }

    button:active {
      background-color: ${accent};
      color: ${fgOnAccent};
      opacity: 0.8;
    }

    label {
      color: ${fg};
    }

    comboboxtext button {
      background-color: ${bg2};
      color: ${fg};
    }

    comboboxtext button:hover {
      background-color: ${accent};
      color: ${fgOnAccent};
    }
  '';

  qt5ctConfTemplate = pkgs.writeText "qt5ct.conf.template" ''
    [Appearance]
    color_scheme_path=__HOME__/.config/qt5ct/colors/theme-switch.conf
    custom_palette=true
    icon_theme=Papirus-Dark
    standard_dialogs=default
    style=Fusion
    stylesheets=__HOME__/.config/qt5ct/qss/theme-switch.qss

    [Fonts]
    fixed="FiraCode Nerd Font Mono,10,-1,5,50,0,0,0,0,0"
    general="Noto Sans,10,-1,5,50,0,0,0,0,0"
  '';

  withAssets = t: t // {
    rofiTheme     = mkRofiTheme     t.rofiColors;
    switcherTheme = mkSwitcherTheme t.rofiColors;
    dunstConf     = mkDunstConf t.dunstColors;
    tmuxConf      = mkTmuxConf  t.tmuxColors;
    gtkSettings   = mkGtkSettings { theme = t.gtkTheme; icons = t.gtkIcons; };
    firefoxCss      = mkUserChromeCss t.tmuxColors;
    vscodeSettings  = mkVscodeSettings t.vscodeThemeName;
    qt5ctColors     = mkQt5ctColors t.tmuxColors;
    qt5ctQss        = mkQt5ctQss t.tmuxColors;
    swaylockConf    = mkSwaylockConf t.swaylockColors;
    regreetCss      = mkRegreetCss t.tmuxColors;
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
      ln -sf "${t.rofiTheme}"       "$HOME/.config/rofi/theme.rasi"
      ln -sf "${t.switcherTheme}"   "$HOME/.config/rofi/switcher.rasi"
      mkdir -p "$HOME/.config/kitty" "$HOME/.config/dunst" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" "$HOME/.config/swaylock"
      ln -sf "${t.kittyColors}"   "$HOME/.config/kitty/current-theme.conf"
      ln -sf "${t.dunstConf}"     "$HOME/.config/dunst/dunstrc"
      ln -sf "${t.swaylockConf}" "$HOME/.config/swaylock/config"
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
      mkdir -p "$HOME/.config/Code/User"
      ln -sf "${t.vscodeSettings}" "$HOME/.config/Code/User/settings.json"
      for _zp in "$HOME/.zen"/*/ "$HOME/.mozilla/firefox"/*/; do
        [ -f "$_zp/cert9.db" ] || continue
        mkdir -p "$_zp/chrome"
        ln -sf "${t.firefoxCss}" "$_zp/chrome/userChrome.css"
      done
      mkdir -p "$HOME/.config/qt5ct/colors" "$HOME/.config/qt5ct/qss"
      ln -sf "${t.qt5ctColors}" "$HOME/.config/qt5ct/colors/theme-switch.conf"
      ln -sf "${t.qt5ctQss}"    "$HOME/.config/qt5ct/qss/theme-switch.qss"
      ln -sf "${t.tmuxConf}"   "$HOME/.config/tmux/theme.conf"
      ln -sf "${t.regreetCss}" /var/lib/regreet-theme/regreet.css 2>/dev/null || true
      ln -sf "${t.wallpaper}"  /var/lib/regreet-theme/wallpaper   2>/dev/null || true
      if [ "''${THEME_PICKER_PREVIEW:-0}" = "0" ]; then
        printf '%s' "${t.name}"              > "$HOME/.cache/current-theme"
        printf '%s' "${t.neovimColorscheme}" > "$HOME/.cache/nvim-colorscheme"
        notify-send "󰏘 Theme" "Switched to ${t.name}" --icon=preferences-desktop-theme
      fi
    ;;
  '';

  themeBlock    = lib.concatStrings (map applyCase allThemes);
  themeIconCase = lib.concatMapStrings (t: ''
      "${t.name}") echo "${t.previewPng}" ;;
  '') allThemes;

  nordFull = withAssets nord;

  # Shell case entries used by initTheme to set asset variables for any theme
  themeInitCase = lib.concatMapStrings (t: ''
      "${t.name}")
        _waybarCss="${t.waybarCss}"
        _starshipToml="${t.starshipToml}"
        _rofiTheme="${t.rofiTheme}"
        _switcherTheme="${t.switcherTheme}"
        _dunstConf="${t.dunstConf}"
        _kittyColors="${t.kittyColors}"
        _gtkSettings="${t.gtkSettings}"
        _wallpaper="${t.wallpaper}"
        _vscodeSettings="${t.vscodeSettings}"
        _firefoxCss="${t.firefoxCss}"
        _swaylockConf="${t.swaylockConf}"
        _qt5ctColors="${t.qt5ctColors}"
        _qt5ctQss="${t.qt5ctQss}"
        _regreetCss="${t.regreetCss}"
        _tmuxConf="${t.tmuxConf}"
        ;;
  '') allThemes;
in
{
  # Qt5 theming via qt5ct – applies themed palette to KeePassXC and other Qt apps.
  # KeePassXC must be set to View > Theme > Classic (Platform-native) for this to work.
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
  };

  # Install all theme neovim plugins so :colorscheme works after live switch
  programs.neovim.plugins = map (t: t.neovimPlugin) allThemes;

  # Install all theme VSCode extensions so workbench.colorTheme works after live switch
  programs.vscode.profiles.default.extensions = map (t: t.vscodeExtension) allThemes;

  # Remove files that HM now owns (e.g. rofi/config.rasi) but were previously
  # managed by theme-switch. Must run before writeBoundary so HM can write freely.
  # Only rofi/config.rasi needs clearing: it was previously owned by theme-switch,
  # now HM owns it. gtk settings.ini was previously HM-managed and is now unmanaged
  # (HM auto-cleans it on first rebuild; no need to clear it here or it resets on every rebuild).
  home.activation.clearThemeMigration = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f "$HOME/.config/rofi/config.rasi"
    rm -f "$HOME/.config/Code/User/settings.json"
    rm -f "$HOME/.config/swaylock/config"
  '';

  # On first activation (or after a theme-switch reset), create initial symlinks
  # pointing to the last-used theme (from ~/.cache/current-theme), falling back to Nord.
  # If a file is already a symlink (set by theme-switch), leave it alone.
  home.activation.initTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/waybar" "$HOME/.config/rofi" "$HOME/.config/dunst" \
             "$HOME/.config/kitty" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0" \
             "$HOME/.config/swaylock" "$HOME/.wallpapers"
    _INIT_THEME=$(cat "$HOME/.cache/current-theme" 2>/dev/null || echo "Nord")
    case "$_INIT_THEME" in
      ${themeInitCase}
      *)
        _waybarCss="${nordFull.waybarCss}"
        _starshipToml="${nordFull.starshipToml}"
        _rofiTheme="${nordFull.rofiTheme}"
        _switcherTheme="${nordFull.switcherTheme}"
        _dunstConf="${nordFull.dunstConf}"
        _kittyColors="${nordFull.kittyColors}"
        _gtkSettings="${nordFull.gtkSettings}"
        _wallpaper="${nordFull.wallpaper}"
        _vscodeSettings="${nordFull.vscodeSettings}"
        _firefoxCss="${nordFull.firefoxCss}"
        _swaylockConf="${nordFull.swaylockConf}"
        _qt5ctColors="${nordFull.qt5ctColors}"
        _qt5ctQss="${nordFull.qt5ctQss}"
        _regreetCss="${nordFull.regreetCss}"
        _tmuxConf="${nordFull.tmuxConf}"
        ;;
    esac
    [ -L "$HOME/.config/waybar/style.css"         ] || ln -sf "$_waybarCss"      "$HOME/.config/waybar/style.css"
    [ -L "$HOME/.config/starship.toml"            ] || ln -sf "$_starshipToml"   "$HOME/.config/starship.toml"
    [ -L "$HOME/.config/rofi/theme.rasi"           ] || ln -sf "$_rofiTheme"      "$HOME/.config/rofi/theme.rasi"
    [ -L "$HOME/.config/rofi/switcher.rasi"        ] || ln -sf "$_switcherTheme"  "$HOME/.config/rofi/switcher.rasi"
    [ -L "$HOME/.config/dunst/dunstrc"            ] || ln -sf "$_dunstConf"      "$HOME/.config/dunst/dunstrc"
    [ -L "$HOME/.config/swaylock/config"          ] || ln -sf "$_swaylockConf" "$HOME/.config/swaylock/config"
    [ -L "$HOME/.config/kitty/current-theme.conf" ] || ln -sf "$_kittyColors"    "$HOME/.config/kitty/current-theme.conf"
    [ -L "$HOME/.config/gtk-3.0/settings.ini"     ] || ln -sf "$_gtkSettings"    "$HOME/.config/gtk-3.0/settings.ini"
    [ -L "$HOME/.config/gtk-4.0/settings.ini"     ] || ln -sf "$_gtkSettings"    "$HOME/.config/gtk-4.0/settings.ini"
    [ -L "$HOME/.wallpapers/wallpaper.png"        ] || ln -sf "$_wallpaper"      "$HOME/.wallpapers/wallpaper.png"
    mkdir -p "$HOME/.config/Code/User"
    [ -L "$HOME/.config/Code/User/settings.json"  ] || ln -sf "$_vscodeSettings" "$HOME/.config/Code/User/settings.json"
    for _zp in "$HOME/.zen"/*/ "$HOME/.mozilla/firefox"/*/; do
      [ -f "$_zp/cert9.db" ] || continue
      mkdir -p "$_zp/chrome"
      [ -L "$_zp/chrome/userChrome.css" ] || ln -sf "$_firefoxCss" "$_zp/chrome/userChrome.css"
    done
    mkdir -p "$HOME/.config/qt5ct/colors" "$HOME/.config/qt5ct/qss"
    [ -L "$HOME/.config/qt5ct/colors/theme-switch.conf" ] || ln -sf "$_qt5ctColors" "$HOME/.config/qt5ct/colors/theme-switch.conf"
    [ -L "$HOME/.config/qt5ct/qss/theme-switch.qss" ]    || ln -sf "$_qt5ctQss"    "$HOME/.config/qt5ct/qss/theme-switch.qss"
    sed "s|__HOME__|$HOME|g" "${qt5ctConfTemplate}" > "$HOME/.config/qt5ct/qt5ct.conf"
    [ -L "$HOME/.config/tmux/theme.conf" ] || ln -sf "$_tmuxConf" "$HOME/.config/tmux/theme.conf"
    [ -L /var/lib/regreet-theme/regreet.css ] || ln -sf "$_regreetCss" /var/lib/regreet-theme/regreet.css 2>/dev/null || true
    [ -L /var/lib/regreet-theme/wallpaper ]   || ln -sf "$_wallpaper"  /var/lib/regreet-theme/wallpaper   2>/dev/null || true
  '';

  home.packages = with pkgs; [
    # Qt5 platform theme plugin (qt module sets env var but may not install the plugin)
    libsForQt5.qt5ct

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
      runtimeInputs = with pkgs; [ swww tmux glib dconf libnotify procps coreutils gnused ];
      # kitty, nvim, rofi come from home-manager; bare names work fine
      text = ''
        # ── icon path lookup by theme name ────────────────────────────────
        _icon_for() {
          case "$1" in
            ${themeIconCase}
            *) echo "" ;;
          esac
        }

        # ── apply theme (set THEME_PICKER_PREVIEW=1 to skip cache/notify) ─
        _apply() {
          case "$1" in
            ${themeBlock}
            *) return 1 ;;
          esac
        }

        # ── rofi script-mode handler: theme-switch --pick [SELECTED] ──────
        if [ "''${1:-}" = "--pick" ]; then
          SEL="''${2:-}"
          _SAVED=$(cat "$HOME/.cache/theme-switch-saved" 2>/dev/null || echo "Nord")

          if [ -z "$SEL" ]; then
            # Initial listing
            printf '\0prompt\x1f󰏘  Theme\n'
            printf '\0message\x1fEnter=preview  ·  Esc=revert to %s\n' "$_SAVED"
            printf '\0no-custom\x1ftrue\n'
            ${themeEntries}
            exit 0
          fi

          if [[ "$SEL" == "✓  Keep: "* ]]; then
            # User confirmed the current preview
            THEME="''${SEL#"✓  Keep: "}"
            printf '%s' "$THEME" > "$HOME/.cache/theme-switch-confirm"
            exit 0
          fi

          # Preview: apply visuals without updating cache or sending notification
          export THEME_PICKER_PREVIEW=1
          _apply "$SEL" 2>/dev/null || true
          export THEME_PICKER_PREVIEW=0

          _icon=$(_icon_for "$SEL")
          printf '\0prompt\x1f󰏘  Previewing: %s\n' "$SEL"
          printf '\0message\x1fEnter=keep  ·  pick another to preview  ·  Esc=revert\n'
          printf '\0keep-selection\x1ftrue\n'
          if [ -n "$_icon" ]; then
            printf '✓  Keep: %s\x00icon\x1f%s\n' "$SEL" "$_icon"
          else
            printf '✓  Keep: %s\n' "$SEL"
          fi
          ${themeEntries}
          exit 0
        fi

        # ── main entry point ───────────────────────────────────────────────
        _SAVED=$(cat "$HOME/.cache/current-theme" 2>/dev/null || echo "Nord")
        printf '%s' "$_SAVED" > "$HOME/.cache/theme-switch-saved"
        rm -f "$HOME/.cache/theme-switch-confirm"

        rofi -modi "pick:theme-switch --pick" -show pick \
            -show-icons \
            -theme "$HOME/.config/rofi/switcher.rasi"

        # Confirm or revert
        if [ -f "$HOME/.cache/theme-switch-confirm" ]; then
          THEME=$(cat "$HOME/.cache/theme-switch-confirm")
          rm -f "$HOME/.cache/theme-switch-confirm"
          _apply "$THEME"
        else
          # Escape pressed (or crash): revert to original
          _apply "$_SAVED" 2>/dev/null || true
        fi
        rm -f "$HOME/.cache/theme-switch-saved"
      '';
    })
  ];
}
