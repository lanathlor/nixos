with import <nixpkgs> { };
pkgs.mkShell {
  nativeBuildInputs = with buildPackages; [ gnumake nixos-generators git ];
  shellHook = ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ gcc.cc.lib ]}
  '';
}
