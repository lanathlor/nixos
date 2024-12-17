{ ... }:
let
  mushu = import ./mushu.nix {
    username = "mushu";
    initialHashedPassword = "***REMOVED-PASSWORD-HASH***";
  };
in
{
  imports = [
    mushu
  ];
}
