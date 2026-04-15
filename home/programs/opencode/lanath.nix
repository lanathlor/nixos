{ ... }:
{
  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";

    model = "ollama/gemma4:26b";
    autoupdate = "notify";

    disabled_providers = [ "opencode" ];

    provider = {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (local)";
        options = {
          baseURL = "http://localhost:11434/v1";
          toolParser = [
            { type = "raw-function-call"; }
            { type = "json"; }
          ];
        };
        models = {
          "gemma4:e4b" = {
            name = "Gemma 4 E4B";
            tool_call = true;
            thinking = true;
            limit = {
              context = 98304;
              output = 8192;
            };
          };
          "gemma4:26b" = {
            name = "Gemma 4 26B MoE";
            tool_call = true;
            thinking = true;
            limit = {
              context = 98304;
              output = 8192;
            };
          };
        };
      };
    };

    compaction = {
      auto = true;
      prune = true;
    };

    watcher = {
      ignore = [
        "**/.git/**"
        "**/node_modules/**"
        "**/dist/**"
        "**/build/**"
        "**/.next/**"
        "**/coverage/**"
        "**/tmp/**"
      ];
    };

    formatter = {
      prettier = {
        command = [
          "bunx"
          "prettier"
          "--write"
          "$FILE"
        ];
        extensions = [
          ".js"
          ".jsx"
          ".ts"
          ".tsx"
          ".json"
          ".md"
          ".yaml"
          ".yml"
          ".css"
          ".html"
        ];
      };
      gofmt = {
        command = [
          "gofmt"
          "-w"
          "$FILE"
        ];
        extensions = [ ".go" ];
      };
    };

    mcp = {
      playwright = {
        type = "local";
        command = [
          "npx"
          "-y"
          "@modelcontextprotocol/server-playwright"
        ];
        enabled = true;
      };
      gitlab = {
        type = "local";
        command = [
          "sh"
          "-c"
          "GITLAB_PERSONAL_ACCESS_TOKEN=$(cat /run/secrets/gitlab_token) npx -y @modelcontextprotocol/server-gitlab"
        ];
        enabled = true;
      };
      github = {
        type = "local";
        command = [
          "sh"
          "-c"
          "GITHUB_PERSONAL_ACCESS_TOKEN=$(cat /run/secrets/github_token) npx -y @modelcontextprotocol/server-github"
        ];
        enabled = true;
      };
    };

    permission = {
      external_directory = "ask";
      doom_loop = "ask";

      read = {
        "*" = "allow";
        "*.env" = "deny";
        "*.env.*" = "deny";
        "*.env.example" = "allow";
        "**/id_rsa" = "deny";
        "**/*.pem" = "deny";
      };

      edit = {
        "*" = "allow";
        "*.env" = "ask";
        "*.env.*" = "ask";
        "**/.git/**" = "deny";
        "**/id_rsa" = "deny";
        "**/*.pem" = "deny";
      };

      bash = {
        "*" = "ask";

        "git status*" = "allow";
        "git diff*" = "allow";
        "git log*" = "allow";
        "git show*" = "allow";
        "git branch*" = "allow";
        "git fetch*" = "allow";

        "git commit*" = "allow";
        "git push*" = "ask";
        "git push --force*" = "deny";
        "git push -f*" = "deny";

        "bun *" = "allow";
        "bunx *" = "allow";
        "npm *" = "allow";
        "npx *" = "allow";
        "pnpm *" = "allow";
        "yarn *" = "allow";

        "go test*" = "allow";
        "go vet*" = "allow";
        "go fmt*" = "allow";
        "gofmt*" = "allow";
        "go list*" = "allow";
        "go build*" = "allow";
        "go run*" = "ask";
        "go generate*" = "ask";

        "docker compose*" = "allow";
        "docker build*" = "allow";
        "docker ps*" = "allow";
        "docker logs*" = "allow";
        "docker exec*" = "ask";
        "docker run*" = "ask";
        "docker rm*" = "ask";
        "docker system prune*" = "ask";

        "rm *" = "deny";
        "sudo *" = "ask";
        "shutdown*" = "deny";
        "reboot*" = "deny";
        "mkfs*" = "deny";
        "dd *" = "deny";
      };

      webfetch = "allow";
    };

    command = {
      status = {
        description = "Show git status + diff; ask for next steps";
        template = "Repo state:\n!`git status --porcelain=v1`\n\nWorking diff:\n!`git diff`\n\nExplain what's going on and recommend next steps.";
      };
      test = {
        description = "Run tests (Go and/or JS) and summarize failures";
        template = "Run the project's test suite(s) and summarize any failures.\n\nGo:\n!`test -f go.mod && go test ./... || true`\n\nJS/TS:\n!`test -f package.json && ( (test -f bun.lockb -o -f bun.lock && bun test) || (test -f pnpm-lock.yaml && pnpm test) || (test -f yarn.lock && yarn test) || npm test ) || true`\n\nIf there are failures, point to the most likely root cause and the minimal fix.";
      };
      lint = {
        description = "Run lint/format checks and propose minimal fixes";
        template = "Run lint/format checks and propose minimal fixes.\n\nGo:\n!`test -f go.mod && (gofmt -w $(go list -f '{{.Dir}}' ./... 2>/dev/null | tr '\\n' ' ') 2>/dev/null || true) && (go vet ./... || true) || true`\n\nJS/TS:\n!`test -f package.json && ( (test -f biome.json -o -f biome.jsonc && bunx biome check .) || (test -f .eslintrc -o -f .eslintrc.js -o -f .eslintrc.cjs -o -f eslint.config.js && bunx eslint .) || true ) || true`\n\nIf a command fails because a tool isn't installed, say what to install and keep going.";
      };
      check = {
        description = "Run all quality checks: type check, lint, and tests";
        template = "Run comprehensive quality checks (type check + lint + tests) and report any issues.\n\n## TypeScript Type Check\n!`test -f tsconfig.json && ( (command -v bunx &> /dev/null && bunx tsc --noEmit) || (command -v npx &> /dev/null && npx tsc --noEmit) ) || echo 'No TypeScript config found'`\n\n## Linting\nGo:\n!`test -f go.mod && (go vet ./... 2>&1 && gofmt -l $(go list -f '{{.Dir}}' ./... 2>/dev/null | tr '\\n' ' ') 2>/dev/null) || echo 'No Go project found'`\n\nJS/TS:\n!`test -f package.json && ( (test -f biome.json -o -f biome.jsonc && bunx biome check .) || (test -f .eslintrc -o -f .eslintrc.js -o -f .eslintrc.cjs -o -f eslint.config.js && bunx eslint .) || echo 'No linter config found' ) || echo 'No package.json found'`\n\n## Tests\nGo:\n!`test -f go.mod && go test ./... || echo 'No Go tests'`\n\nJS/TS:\n!`test -f package.json && grep -q '\"test\"' package.json && ( (test -f bun.lockb -o -f bun.lock && bun test) || (test -f pnpm-lock.yaml && pnpm test) || (test -f yarn.lock && yarn test) || npm test ) || echo 'No test script defined'`\n\n---\n\nSummarize the results. If all checks pass, confirm. If any fail, list specific issues and recommend fixes.";
      };
    };
  };
}
