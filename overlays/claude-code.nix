final: prev: {
  claude-code = final.stdenv.mkDerivation rec {
    pname = "claude-code";
    version = "2.1.175";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code-linux-x64/-/claude-code-linux-x64-${version}.tgz";
      hash = "sha256-NsMaez7G2wUWBJNxUazYlWnD0TBDm+qMKwBOcTJSjSw=";
    };

    nativeBuildInputs = [ final.patchelf ];

    dontBuild = true;
    dontConfigure = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp claude $out/bin/claude
      chmod +x $out/bin/claude

      # Only patch the ELF interpreter — do NOT use autoPatchelfHook or add
      # RPATH entries, as resizing ELF sections corrupts the Bun application
      # bytecode appended after the ELF data.
      patchelf --set-interpreter "$(cat ${final.stdenv.cc}/nix-support/dynamic-linker)" \
        $out/bin/claude

      runHook postInstall
    '';

    meta = with final.lib; {
      description = "Claude Code CLI - Official Anthropic CLI for Claude";
      homepage = "https://github.com/anthropics/claude-code";
      license = licenses.unfree;
      maintainers = [ ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
