# 🎨 Dotfiles Environment Setup

<div align="center">

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![ZSH](https://img.shields.io/badge/ZSH-F15A24?style=for-the-badge&logo=zsh&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

*A comprehensive dotfiles configuration for Arch Linux with HyDE, ZSH, and security tools*

</div>

---

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [🎯 HyDE Installation](#-hyde-installation)
- [🐚 ZSH Setup](#-zsh-setup)
- [🔒 Security Tools](#-security-tools)
- [📝 Prerequisites](#-prerequisites)

---

## 📝 Prerequisites

This configuration depends on the **HyDE Project**:
- 🔗 **Repository**: [HyDE-Project/HyDE](https://github.com/HyDE-Project/HyDE)
- 🖥️ **OS**: Arch Linux (recommended)
- 🛠️ **Tools**: Git, base-devel package group

---

## 🚀 Quick Start

### 1️⃣ Initial Setup

```bash
# Install essential packages
pacman -S --needed git base-devel

# Clone HyDE project
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE

# Navigate and install
cd ~/HyDE/Scripts
./install.sh

# Restart system
reboot
```

### 🔄 Update HyDE

> **💡 Tip**: Keep your HyDE installation up to date with these commands:

```bash
cd ~/HyDE/Scripts
git pull origin master
./install.sh -r
```

---

## 🐚 ZSH Setup

Transform your shell experience with Oh My Zsh and powerful plugins!

### 🎯 Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 🔧 Install Essential Plugins & Dependencies

```bash
# Install FZF for fuzzy finding
sudo pacman -Syu fzf

# Syntax highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Auto-completions plugin
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

# Auto-suggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# FZF tab completion
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

# Pure theme for a clean prompt
git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/custom/pure"

# Apply custom zshrc configuration
curl -o ~/.zshrc https://raw.githubusercontent.com/Denos-soneD/zshrc/main/zshrc && source ~/.zshrc
```

### 🌟 Features Included

- **🎨 Syntax Highlighting**: Color-coded commands
- **💡 Auto-suggestions**: Smart command completion
- **🔍 Fuzzy Finding**: Quick file and command search
- **✨ Pure Theme**: Minimal and elegant prompt
- **⚡ Enhanced Tab Completion**: Improved navigation

---

## 🔒 Security Tools

### 🛡️ BlackArch & YAY Installation

```bash
# Download and install BlackArch
curl -O https://blackarch.org/strap.sh
sudo chmod +x strap.sh
sudo ./strap.sh

# Update system packages
sudo pacman -Syyu --noconfirm

# Install YAY AUR helper
sudo pacman -S yay --noconfirm
```

### 🔍 What's Included

- **🏴‍☠️ BlackArch**: Penetration testing and security research tools
- **📦 YAY**: AUR helper for extended package management
- **🔧 Extended toolset**: Access to thousands of security tools

---

## 🎉 Final Notes

After completing the installation:

1. **🔄 Restart your terminal** to apply ZSH changes
2. **🎨 Customize** your configuration as needed
3. **🚀 Enjoy** your enhanced development environment!

---

<div align="center">

**⭐ Star this repository if it helped you!**

*Made with ❤️ by [Denos-soneD](https://github.com/Denos-soneD)*

</div>