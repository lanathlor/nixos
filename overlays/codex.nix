final: prev: {
  codex = final.stdenv.mkDerivation rec {
    pname = "codex";
    version = "0.113.0";

    src = final.fetchurl {
      url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}.tgz";
      hash = "sha256-SzBC6NqveUbZVWUVPWtCSaQZuX2ZUY5xxjphA1WZlIA=";
    };

    srcPlatform = final.fetchurl {
      url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}-linux-x64.tgz";
      hash = "sha256-SNe/LMuQDJJONocCnVeOjhG1UnABR9yUQRmc1kZb5SA=";
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
