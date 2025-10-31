# AGENTS

- Agent Workflow
  - Manager agent uses a three-step workflow for all requests:
    1. **Prompt-engineer** agent clarifies and optimizes the request
    2. **Specialized agent(s)** handle the task (architect, refactor, test-writer, security-auditor, etc.)
    3. **Critic** agent reviews and validates the solution before delivery
  - New critic agent ensures quality control and catches issues before final output

- Build / install
  - `cd opencode && npm ci` — install JS deps used by tools/plugins
  - `./install.sh` — repo-level installer for dotfiles (where applicable)

- Lint / format / test commands
  - Format Lua: `stylua .` (repo contains `stylua.toml`)
  - Lint Lua (if installed): `luacheck .`
  - Run JS tests (if added): `cd opencode && npm test` and single test: `npm test -- -t "pattern"`
  - Common single-test patterns:
    - Python/pytest: `pytest path/to/test.py::test_name -q`
    - Go: `go test ./... -run TestName`
    - Rust: `cargo test test_name`

- Style / code guidelines (for agents)
  - Formatting: run `stylua` on Lua files before committing; keep `stylua.toml` settings.
  - Imports / requires: group standard, external, then internal requires; one blank line between groups.
  - Naming: use `snake_case` for Lua functions/variables, `PascalCase` for module/file names where appropriate.
  - Types & annotations: Lua is dynamic — prefer clear variable names and local scoping (`local`) to avoid globals; add inline comments for complex return types.
  - Error handling: return `nil, err` from functions that can fail; callers should check and propagate errors; use `pcall`/`xpcall` only when isolating plugin failures.
  - Small functions: keep functions small and single-responsibility; prefer explicit returns over side-effects.
  - Commits & edits: be surgical — change only necessary files and include a short, descriptive commit message.

- Tooling / rules notes
  - No `.cursor` or Copilot instruction files were found; no extra Cursor/Copilot rules to apply.

If you add tests or other languages, update this AGENTS.md with exact test runner commands and any new linters.
