{ ... }:
let
  mushu = import ./default.nix {
    username = "mushu";
    initialHashedPassword = "***REMOVED-PASSWORD-HASH***";
  };
in
{
  imports = [
    mushu
  ];
}
