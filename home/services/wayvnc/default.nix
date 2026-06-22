{ pkgs, localConfig, lib, ... }:
let
  wayvnc-all = pkgs.writeShellScript "wayvnc-all" ''
    set -euo pipefail
    PORT=5900
    PIDS=()

    cleanup() {
      for pid in "''${PIDS[@]}"; do
        kill "$pid" 2>/dev/null || true
      done
    }
    trap cleanup EXIT

    # Wait for Hyprland to be ready
    for i in $(seq 1 30); do
      ${pkgs.hyprland}/bin/hyprctl monitors -j >/dev/null 2>&1 && break
      sleep 1
    done

    for output in $(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name'); do
      echo "Starting wayvnc on output $output → 127.0.0.1:$PORT"
      ${pkgs.wayvnc}/bin/wayvnc -o "$output" 127.0.0.1 "$PORT" &
      PIDS+=($!)
      PORT=$((PORT + 1))
    done

    # Wait for any child to exit
    wait -n || true
    # If one dies, stop them all
    cleanup
  '';
in
lib.mkIf localConfig.wayvnc.enable {
  systemd.user.services.wayvnc = {
    Unit = {
      Description = "wayvnc - VNC server for all outputs";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${wayvnc-all}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
