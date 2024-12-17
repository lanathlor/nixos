{ ... }:
let
  lanath = import ./default.nix {
    username = "lanath";
    initialHashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";
  };
in
{
  imports = [
    lanath
  ];
}
