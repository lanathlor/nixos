# KDE Plasma configured to feel like Hyprland: dynamic tiling via Krohnkite,
# matching gaps, and the same keybindings as home/programs/hyprland.
# Only active when kde.enable is set for the host (see config-defaults.nix).
{ lib, localConfig, ... }:
let
  inherit (builtins) toString;

  # Virtual desktops stand in for Hyprland workspaces (1..10, key 10 -> "0").
  desktops = lib.range 1 10;
  keyOf = n: if n == 10 then "0" else toString n;

  switchToDesktop = lib.listToAttrs (map
    (n: lib.nameValuePair "Switch to Desktop ${toString n}" "Meta+${keyOf n}")
    desktops);
  windowToDesktop = lib.listToAttrs (map
    (n: lib.nameValuePair "Window to Desktop ${toString n}" "Meta+Shift+${keyOf n}")
    desktops);
  # Free Meta+<n> from the task manager so it switches desktops instead.
  clearTaskbarEntries = lib.listToAttrs (map
    (n: lib.nameValuePair "activate task manager entry ${keyOf n}" [ ])
    desktops);

  kwinShortcuts = {
    # --- Window ops (mirror Hyprland binds) ---
    "Window Close" = "Meta+A"; # Super+A killactive
    "Window Fullscreen" = "Meta+F"; # Super+F fullscreen
    "Window Operations Menu" = [ ]; # avoid Meta+Alt+F clutter

    # Free Meta+arrows from KWin Quick Tile so Krohnkite can use them for focus.
    "Window Quick Tile Left" = [ ];
    "Window Quick Tile Right" = [ ];
    "Window Quick Tile Top" = [ ];
    "Window Quick Tile Bottom" = [ ];
    "Window Maximize" = [ ];

    # --- Krohnkite (keyed by ShortcutHandler `name`) ---
    # Focus: arrows (Hyprland uses arrows) + hjkl as a bonus.
    "KrohnkiteFocusLeft" = [ "Meta+Left" "Meta+H" ];
    "KrohnkiteFocusDown" = [ "Meta+Down" "Meta+J" ];
    "KrohnkiteFocusUp" = [ "Meta+Up" "Meta+K" ];
    "KrohnkiteFocusRight" = [ "Meta+Right" "Meta+L" ];
    # Move window: Super+Shift+arrows (+ hjkl).
    "KrohnkiteShiftLeft" = [ "Meta+Shift+Left" "Meta+Shift+H" ];
    "KrohnkiteShiftDown" = [ "Meta+Shift+Down" "Meta+Shift+J" ];
    "KrohnkiteShiftUp" = [ "Meta+Shift+Up" "Meta+Shift+K" ];
    "KrohnkiteShiftRight" = [ "Meta+Shift+Right" "Meta+Shift+L" ];
    # Toggle float on Super+V (Hyprland togglefloating), freeing Meta+F for fullscreen.
    "KrohnkiteToggleFloat" = "Meta+V";
    # Set master moved off Meta+Return (that's the terminal now).
    "KrohnkiteSetMaster" = "Meta+Shift+Return";
    # Layout cycling / presets kept on Krohnkite defaults: Meta+\, Meta+T, Meta+M.
  };
in
lib.mkIf localConfig.kde.enable {
  programs.plasma = {
    enable = true;

    kwin.virtualDesktops = {
      number = 10;
      rows = 1;
    };

    shortcuts = {
      kwin = kwinShortcuts // switchToDesktop // windowToDesktop;
      plasmashell = clearTaskbarEntries;
      ksmserver."Lock Session" = [ "Meta+L" "Screensaver" ]; # Super+L lock
    };

    # App launches (Hyprland exec binds). krunner toggles the launcher like rofi.
    hotkeys.commands = {
      launch-terminal = {
        name = "Launch Terminal";
        key = "Meta+Return";
        command = "kitty";
      };
      launch-files = {
        name = "Launch File Manager";
        key = "Meta+E";
        command = "dolphin";
      };
      launch-launcher = {
        name = "Launch KRunner";
        key = "Meta+Space";
        command = "krunner";
      };
    };

    # Enable Krohnkite and match Hyprland's gaps (gaps_out = 20, gaps_in = 5).
    configFile.kwinrc = {
      "Plugins"."krohnkiteEnabled" = true;
      "Script-krohnkite" = {
        screenGapTop = 20;
        screenGapBottom = 20;
        screenGapLeft = 20;
        screenGapRight = 20;
        screenGapBetween = 5;
        # Cleaner single-window look, like Hyprland with one tile.
        soleWindowNoBorders = true;
        soleWindowNoGaps = true;
      };
    };
  };
}
