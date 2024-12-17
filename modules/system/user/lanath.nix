{ ... }:
let
  lanath = import ./lanath.nix {
    username = "lanath";
    initialHashedPassword = "***REMOVED-PASSWORD-HASH***";
  };
in
{
  imports = [
    lanath
  ];
}
