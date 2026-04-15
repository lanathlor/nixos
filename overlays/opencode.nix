final: prev: {
  opencode = final.stdenv.mkDerivation rec {
    pname = "opencode";
    version = "1.4.3";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/opencode-linux-x64/-/opencode-linux-x64-${version}.tgz";
      hash = "sha256-U31zYCoUk8vFVIbMJvNI1PAzK+5R8zcN3y8OWW5X7bg=";
    };

    nativeBuildInputs = [ final.patchelf ];

    dontBuild = true;
    dontConfigure = true;
    dontStrip = true;
    dontPatchELF = true;

    unpackPhase = ''
      mkdir -p source
      tar -xzf ${src} --strip-components=1 -C source
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      install -m 755 source/bin/opencode $out/bin/opencode

      # Bun-compiled binaries embed app code after the ELF segments.
      # Only patch the interpreter — do not strip or modify sections.
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/opencode

      runHook postInstall
    '';

    meta = with final.lib; {
      description = "OpenCode - Open source AI coding agent for the terminal";
      homepage = "https://opencode.ai";
      license = licenses.mit;
      maintainers = [ ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
