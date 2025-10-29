# Agent Guidelines for Dotfiles Repository

## Build/Test Commands
- Deploy configs: `stow .` (from repo root, symlinks to `~/.config`)
- Install/update environment: `./install.sh` (multi-OS automated setup)
- Setup tmux plugins: `./setup-tmux.sh`
- Test configs: `source ~/.config/zsh/.zshrc` (zsh), `nvim` (auto-installs plugins), `tmux source ~/.config/tmux/.tmux.conf` (tmux)
- Format Lua: `stylua nvim/` (2-space indent, 120 col width)
- Verify stow links: `stow -n .` (dry-run to preview changes)

## Code Style

### Shell Scripts (Bash/Zsh)
- Shebang: `#!/bin/zsh` or `#!/bin/bash` (prefer zsh for install.sh)
- Error handling: Always use `set -e` at script start
- Variables: UPPERCASE for globals/env, lowercase for locals
- Functions: `snake_case()` with descriptive names (`install_packages`, `print_status`)
- Output: Use color functions (`print_status`, `print_error`, `print_info`, `print_header`)
- Safety checks: Use `is_package_installed()`, `dir_exists()` before operations
- OS detection: Support arch, ubuntu, fedora, centos, macos in case statements
- Idempotency: All operations must be safe to run multiple times
- Directory checks: Always verify paths exist before operations

### Lua (Neovim - LazyVim based)
- Indentation: 2 spaces (see nvim/stylua.toml)
- Line width: 120 characters max
- Style: Minimal, rely on LazyVim defaults
- Plugins: Each in `nvim/lua/plugins/*.lua` as return table (e.g., `return { "plugin/name", lazy = false }`)
- Config: Place in `nvim/lua/config/*.lua` (autocmds, keymaps, options)
- Lazy loading: Use `lazy = false` only when needed (navigation, core functionality)
- Comments: Only when clarifying non-obvious logic
- Imports: Use `require("module")`, avoid unnecessary nesting
- Keymaps: Use `vim.keymap.set()` with descriptive `desc` field

## File Structure
- Configs live in: `{nvim,zsh,tmux,git,ssh,atuin}/` directories
- Stow targets: `~/.config/{nvim,zsh,tmux,git,atuin}` and `~/.ssh/config`
- Scripts: `install.sh` (main setup), `setup-tmux.sh` (tmux plugins)
