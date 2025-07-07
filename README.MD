# 🎨 Dotfiles Configuration

<div align="center">

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![ZSH](https://img.shields.io/badge/ZSH-F15A24?style=for-the-badge&logo=zsh&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![GNU Stow](https://img.shields.io/badge/GNU%20Stow-000000?style=for-the-badge&logo=gnu&logoColor=white)

*Personal dotfiles managed with GNU Stow for Arch Linux*

</div>

---

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [🛠️ What's Included](#-whats-included)
- [🔧 Manual Installation](#-manual-installation)
- [📁 Structure](#-structure)
- [⚙️ Configuration](#-configuration)

---

# 🚀 **AUTOMATED INSTALLATION**

<div align="center">

## ⚡ **One-Command Setup**

```bash
bash <(curl -fsSL 'https://raw.githubusercontent.com/Denos-soneD/dotfiles/refs/heads/main/install.sh')
```

<div style="background-color: #1e1e1e; padding: 20px; border-radius: 10px; margin: 20px 0;">
<h3>🎯 <strong>What this script does:</strong></h3>
<ul>
<li>✅ Installs and configures ZSH with Oh My Zsh</li>
<li>✅ Sets up Neovim with LazyVim</li>
<li>✅ Configures SSH with key generation</li>
<li>✅ Uses GNU Stow for symlink management</li>
<li>✅ Handles all dependencies automatically</li>
</ul>
</div>

</div>

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

## 🔧 Manual Installation

### Prerequisites

```bash
# Install essential packages
sudo pacman -S git stow zsh
```

### Clone and Setup

```bash
# Clone the repository
git clone https://github.com/Denos-soneD/dotfiles.git ~/dotfiles

# Navigate to dotfiles directory
cd ~/dotfiles

# Apply configurations with install.sh
./install.sh
```

---

## 📁 Structure

```
dotfiles/
├── .stowrc                    # Stow configuration
├── install.sh                 # Automated installation script
├── zsh/
│   └── .config/
│       └── zsh/
│           └── .zshrc         # ZSH configuration
├── nvim/
│   └── .config/
│       └── nvim/              # Neovim configuration
├── ssh/
│   └── .ssh/
│       └── config             # SSH configuration
└── tmux/
    └── .tmux.conf            # Tmux configuration
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

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/dotfiles
./install.sh
```

---

<div align="center">

**⭐ Star this repository if it helped you!**

**Made with ❤️ by [Denos-soneD](https://github.com/Denos-soneD)**

*Happy coding! 🚀*

</div>
