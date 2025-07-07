# 🎨 Dotfiles Configuration

---

# 🚀 **AUTOMATED INSTALLATION / UPDATE**

## ⚡ **One-Command Setup**

```bash
bash <(curl -fsSL 'https://raw.githubusercontent.com/Denos-soneD/dotfiles/refs/heads/main/install.sh')
```

---

## 🛠️ What's Included

| Component | Description |
|-----------|-------------|
| 🐚 **ZSH** | Oh My Zsh with plugins and Pure theme |
| 🗂️ **GNU Stow** | Symlink management for dotfiles |
| 🔐 **SSH** | Secure SSH configuration with key generation |
| 📝 **Neovim** | LazyVim configuration with plugins |
| 🎨 **Tmux** | Terminal multiplexer configuration |

---

## 📁 Structure

```
dotfiles/
├── .stowrc                    # Stow configuration
├── install.sh                 # Automated installation script
├── zsh/
│     └── .zshrc               # ZSH configuration
├── nvim/                      # Neovim configuration
├── ssh/
│     └── ssh-config           # SSH configuration
└── tmux/
    └── .tmux.conf             # Tmux configuration
```

---

## ⚙️ Configuration

### ZSH Configuration

The ZSH setup includes:
- 🎨 **Pure theme** for a clean prompt
- 🔍 **Syntax highlighting** for better readability
- 💡 **Auto-suggestions** based on history
- 🚀 **FZF integration** for fuzzy finding
- 📝 **Smart completions** for commands

### SSH Configuration

Secure SSH setup with:
- 🔑 **Automatic key generation** (RSA & ED25519)
- 🛡️ **Secure default settings**
- 🔧 **Pre-configured hosts** (GitHub, etc.)
- 🔐 **Proper file permissions**

### Neovim Configuration

LazyVim-based setup featuring:
- 📦 **Lazy plugin management**
- 🎨 **Modern UI** with telescope, neo-tree
- 🔧 **LSP support** for multiple languages
- 🚀 **Fast startup** with optimized loading

---

<div align="center">

**⭐ Star this repository if it helped you!**

**Made with ❤️ by [Denos-soneD](https://github.com/Denos-soneD)**

*Happy coding! 🚀*

</div>
