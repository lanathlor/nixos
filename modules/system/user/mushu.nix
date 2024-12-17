{ ... }:
let
  mushu = import ./mushu.nix {
    username = "mushu";
    initialHashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";
  };
in
{
  imports = [
    mushu
  ];
}
