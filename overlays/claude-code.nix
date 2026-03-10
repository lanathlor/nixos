final: prev: {
  claude-code = final.stdenv.mkDerivation rec {
    pname = "claude-code";
    version = "2.1.59";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      hash = "sha256-e8Ssqmb7vntrGcQ2ZyLewpji4SjGbiaZ4HrUf17gHSo=";
    };

    nativeBuildInputs = [ final.makeWrapper ];
    buildInputs = [ final.nodejs_22 ];

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/claude-code
      cp -r . $out/lib/claude-code/

      # Remote-control's bridge spawner uses process.execPath (the node
      # binary) to spawn child sessions. On Node.js 22+, this causes
      # "bad option: --sdk-url" because node intercepts unknown flags.
      # Patch the bridge to use process.argv[1] (cli.js) instead, which
      # goes through the shebang and respects '--'.
      sed -i 's|execPath:process\.execPath,env:process\.env|execPath:process.argv[1],env:process.env|' \
        $out/lib/claude-code/cli.js

      mkdir -p $out/bin
      makeWrapper ${final.nodejs_22}/bin/node $out/bin/claude \
        --add-flags "-- $out/lib/claude-code/cli.js"

      runHook postInstall
    '';

    postFixup = ''
      # Patch shebang to include '--' so Node.js doesn't intercept
      # flags like --sdk-url when cli.js is exec'd via shebang
      sed -i '1s|^#!\(.*\)/bin/node.*|#!\1/bin/node --|' $out/lib/claude-code/cli.js
    '';

    meta = with final.lib; {
      description = "Claude Code CLI - Official Anthropic CLI for Claude";
      homepage = "https://github.com/anthropics/claude-code";
      license = licenses.unfree;
      maintainers = [ ];
      platforms = platforms.all;
    };
  };
}
