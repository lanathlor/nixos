final: prev: {
  codex = final.stdenv.mkDerivation rec {
    pname = "codex";
    version = "0.113.0";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}.tgz";
      hash = "sha256-104lk5ah6q9sqrqqwlcrgnwik92989mks5b5apclcydgvbl44c2b";
    };

    srcPlatform = final.fetchurl {
      url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}-linux-x64.tgz";
      hash = "sha256-0875bd3dd70r86adqiq1f19ba4cfirbrs0l76r79434hrcnbzms8";
    };

    nativeBuildInputs = [ final.makeWrapper ];
    buildInputs = [ final.nodejs_22 ];

    dontBuild = true;
    dontConfigure = true;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/codex
      tar -xzf ${src} --strip-components=1 -C $out/lib/codex
      tar -xzf ${srcPlatform} --strip-components=1 -C $out/lib/codex

      mkdir -p $out/bin
      makeWrapper ${final.nodejs_22}/bin/node $out/bin/codex \
        --add-flags "-- $out/lib/codex/bin/codex.js"

      runHook postInstall
    '';

    meta = with final.lib; {
      description = "Codex CLI - OpenAI coding agent";
      homepage = "https://github.com/openai/codex";
      license = licenses.asl20;
      maintainers = [ ];
      platforms = platforms.linux;
    };
  };
}
