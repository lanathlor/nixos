# Sunshine — self-hosted desktop stream host for Moonlight clients. Captures the
# live Hyprland session (video + audio, GPU-encoded, low latency). The kiosk laptop
# connects to it with Moonlight. Needs a logged-in session to capture (no autologin
# here — log in physically before connecting).
{ pkgs, ... }:
let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  jq = "${pkgs.jq}/bin/jq";

  # Resolve the running Hyprland instance even when invoked over SSH (where the
  # session env isn't inherited), so `ssh desktop screen-solo` works.
  hyprEnv = ''
    uid=$(id -u)
    export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$uid}"
    if [ -z "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
      HYPRLAND_INSTANCE_SIGNATURE=$(ls -t "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -n1)
      export HYPRLAND_INSTANCE_SIGNATURE
    fi
  '';

  # screen-solo [OUTPUT] — collapse to a single monitor for streaming. Keeps the
  # named output (or the first one) and disables the rest, so Moonlight gets one
  # clean screen instead of the 3-monitor canvas squished onto the laptop.
  screen-solo = pkgs.writeShellScriptBin "screen-solo" ''
    set -eu
    ${hyprEnv}
    keep="''${1:-}"
    if [ -z "$keep" ]; then
      keep=$(${hyprctl} -j monitors | ${jq} -r '.[0].name')
    fi
    ${hyprctl} -j monitors | ${jq} -r '.[].name' | while read -r m; do
      [ "$m" = "$keep" ] || ${hyprctl} keyword monitor "$m, disable"
    done
    echo "screen-solo: streaming $keep (other outputs disabled)"
  '';

  # screen-multi — restore the full multi-monitor layout (re-applies monitors.conf).
  screen-multi = pkgs.writeShellScriptBin "screen-multi" ''
    set -eu
    ${hyprEnv}
    ${hyprctl} reload
    echo "screen-multi: restored full monitor layout"
  '';
in
{
  services.sunshine = {
    enable = true;
    openFirewall = true; # Sunshine + Moonlight ports on the LAN
    capSysAdmin = true; # required for KMS screen capture under Wayland (Hyprland)
    autoStart = true; # start with the graphical session
  };

  environment.systemPackages = [ screen-solo screen-multi ];
}
