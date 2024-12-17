{ ... }:
let
  lanath = import ./default.nix {
    username = "lanath";
    initialHashedPassword = "***REMOVED-PASSWORD-HASH***";
  };
in
{
  imports = [
    lanath
  ];
}
