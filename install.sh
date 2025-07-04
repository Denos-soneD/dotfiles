#!/bin/bash

# 🎨 Dotfiles Environment Setup - Automated Installation Script
# Made with ❤️ by Denos-soneD

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Icons
CHECKMARK="✅"
CROSS="❌"
WARNING="⚠️"
INFO="ℹ️"
ROCKET="🚀"

# Print colored output
print_status() {
  echo -e "${GREEN}${CHECKMARK} $1${NC}"
}

print_error() {
  echo -e "${RED}${CROSS} $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_info() {
  echo -e "${BLUE}${INFO} $1${NC}"
}

print_header() {
  echo -e "${PURPLE}${ROCKET} $1${NC}"
}

# Check if running as root
check_root() {
  if [[ $EUID -eq 0 ]]; then
    print_error "This script should not be run as root"
    exit 1
  fi
}

# Check if on Arch Linux
check_arch() {
  if ! command -v pacman &>/dev/null; then
    print_error "This script is designed for Arch Linux"
    exit 1
  fi
  print_status "Arch Linux detected"
}

# Check if package is installed
is_package_installed() {
  pacman -Q "$1" &>/dev/null
}

# Check if command exists
command_exists() {
  command -v "$1" &>/dev/null
}

# Check if directory exists
dir_exists() {
  [ -d "$1" ]
}

# Install packages with pacman
install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_package_installed "$pkg"; then
      to_install+=("$pkg")
    else
      print_status "$pkg is already installed"
    fi
  done

  if [ ${#to_install[@]} -gt 0 ]; then
    print_info "Installing packages: ${to_install[*]}"
    sudo pacman -S --needed --noconfirm "${to_install[@]}"
    print_status "Packages installed successfully"
  fi
}

# Install YAY if not present
install_yay() {
  if command_exists yay; then
    print_status "YAY is already installed"
    return
  fi

  print_info "Installing YAY AUR helper..."
  sudo pacman -S --needed --noconfirm yay
  print_status "YAY installed successfully"
}

# HyDE Installation
install_hyde() {
  check_arch
  print_header "Setting up HyDE Environment"

  # Install base packages
  print_info "Installing base packages..."
  install_packages git base-devel

  # Check if HyDE is already installed
  if dir_exists "$HOME/HyDE"; then
    print_warning "HyDE directory already exists. Updating..."
    cd "$HOME/HyDE/Scripts"
    git pull origin master
    ./install.sh -r
  else
    print_info "Cloning HyDE repository..."
    git clone --depth 1 https://github.com/HyDE-Project/HyDE "$HOME/HyDE"
    cd "$HOME/HyDE/Scripts"
    ./install.sh
  fi

  print_status "HyDE installation completed"
}

# ZSH Setup
install_zsh() {
  print_header "Setting up ZSH Environment"

  # Install ZSH and dependencies
  install_packages zsh fzf

  # Install Oh My Zsh
  if dir_exists "$HOME/.oh-my-zsh"; then
    print_status "Oh My Zsh is already installed"
  else
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_status "Oh My Zsh installed successfully"
  fi

  # Install ZSH plugins
  local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  # Syntax highlighting
  if dir_exists "$plugins_dir/zsh-syntax-highlighting"; then
    print_status "zsh-syntax-highlighting already installed"
  else
    print_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
    print_status "zsh-syntax-highlighting installed"
  fi

  # Auto-completions
  if dir_exists "$plugins_dir/zsh-completions"; then
    print_status "zsh-completions already installed"
  else
    print_info "Installing zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions "$plugins_dir/zsh-completions"
    print_status "zsh-completions installed"
  fi

  # Auto-suggestions
  if dir_exists "$plugins_dir/zsh-autosuggestions"; then
    print_status "zsh-autosuggestions already installed"
  else
    print_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
    print_status "zsh-autosuggestions installed"
  fi

  # FZF Tab
  if dir_exists "$plugins_dir/fzf-tab"; then
    print_status "fzf-tab already installed"
  else
    print_info "Installing fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$plugins_dir/fzf-tab"
    print_status "fzf-tab installed"
  fi

  # Pure theme
  if dir_exists "$HOME/.oh-my-zsh/custom/pure"; then
    print_status "Pure theme already installed"
  else
    print_info "Installing Pure theme..."
    git clone https://github.com/sindresorhus/pure.git "$HOME/.oh-my-zsh/custom/pure"
    print_status "Pure theme installed"
  fi

  # Apply custom zshrc
  print_info "Applying custom zshrc configuration..."
  curl -o ~/.zshrc https://raw.githubusercontent.com/Denos-soneD/zshrc/main/zshrc
  print_status "ZSH configuration applied"
}

# Security Tools Installation
install_security_tools() {
  check_arch
  print_header "Setting up Security Tools"

  # Check if BlackArch is already installed
  if pacman -Q blackarch-keyring &>/dev/null; then
    print_status "BlackArch is already installed"
  else
    print_info "Installing BlackArch..."
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh
    sudo ./strap.sh
    rm strap.sh
    print_status "BlackArch installed successfully"
  fi

  # Update system
  print_info "Updating system packages..."
  sudo pacman -Syyu --noconfirm
  print_status "System updated"

  # Install YAY if not present
  install_yay
}

# Neovim Installation
install_neovim() {
  print_header "Setting up Neovim Configuration"

  # Install Neovim and dependencies
  install_packages neovim luarocks git

  # Check if custom nvim config exists
  if dir_exists "$HOME/.config/nvim"; then
    print_warning "Neovim config already exists. Backing up..."
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
  fi

  # Clone custom configuration
  print_info "Installing custom Neovim configuration..."
  git clone https://github.com/Denos-soneD/nvim "$HOME/.config/nvim"
  print_status "Neovim configuration installed"

  print_info "First launch of Neovim will install plugins automatically"
}

# Update function
update_all() {
  print_header "Updating all components"

  # Update HyDE
  if dir_exists "$HOME/HyDE"; then
    print_info "Updating HyDE..."
    cd "$HOME/HyDE/Scripts"
    git pull origin master
    ./install.sh -r
    print_status "HyDE updated"
  fi

  # Update ZSH plugins
  if dir_exists "$HOME/.oh-my-zsh/custom/plugins"; then
    print_info "Updating ZSH plugins..."
    for plugin in "$HOME/.oh-my-zsh/custom/plugins"/*; do
      if [ -d "$plugin/.git" ]; then
        echo "Updating $(basename "$plugin")..."
        cd "$plugin" && git pull
      fi
    done
    print_status "ZSH plugins updated"
  fi

  # Update Neovim config
  if dir_exists "$HOME/.config/nvim/.git"; then
    print_info "Updating Neovim configuration..."
    cd "$HOME/.config/nvim"
    git pull
    print_status "Neovim configuration updated"
  fi

  # Update system packages
  print_info "Updating system packages..."
  sudo pacman -Syyu --noconfirm
  print_status "System packages updated"
}

# Status check function
check_status() {
  print_header "Checking installation status"

  echo
  print_info "System Information:"
  echo "  OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")"
  echo "  Kernel: $(uname -r)"
  echo "  Shell: $SHELL"
  echo

  print_info "Installation Status:"

  # Check HyDE
  if dir_exists "$HOME/HyDE"; then
    print_status "HyDE: Installed"
  else
    print_error "HyDE: Not installed"
  fi

  # Check ZSH
  if dir_exists "$HOME/.oh-my-zsh"; then
    print_status "Oh My Zsh: Installed"
  else
    print_error "Oh My Zsh: Not installed"
  fi

  # Check YAY
  if command_exists yay; then
    print_status "YAY: Installed"
  else
    print_error "YAY: Not installed"
  fi

  # Check BlackArch
  if pacman -Q blackarch-keyring &>/dev/null; then
    print_status "BlackArch: Installed"
  else
    print_error "BlackArch: Not installed"
  fi

  # Check Neovim
  if command_exists nvim; then
    print_status "Neovim: Installed ($(nvim --version | head -1))"
  else
    print_error "Neovim: Not installed"
  fi

  # Check Neovim config
  if dir_exists "$HOME/.config/nvim"; then
    print_status "Neovim Config: Installed"
  else
    print_error "Neovim Config: Not installed"
  fi
}

# Main menu
show_menu() {
  echo
  print_header "Dotfiles Environment Setup Script"
  echo
  echo "Choose an option:"
  echo "1) 🚀 Full Installation (All components)"
  echo "2) 🎯 Install HyDE only"
  echo "3) 🐚 Install ZSH setup only"
  echo "4) 🔒 Install Security Tools only"
  echo "5) 📝 Install Neovim only"
  echo "6) 🔄 Update all components"
  echo "7) 📊 Check installation status"
  echo "8) ❌ Exit"
  echo
  read -p "Enter your choice (1-8): " choice
}

# Main function
main() {
  check_root
  check_arch

  while true; do
    show_menu
    case $choice in
    1)
      install_hyde
      install_zsh
      install_security_tools
      install_neovim
      print_status "Full installation completed! Please reboot your system."
      break
      ;;
    2)
      install_hyde
      break
      ;;
    3)
      install_zsh
      break
      ;;
    4)
      install_security_tools
      break
      ;;
    5)
      install_neovim
      break
      ;;
    6)
      update_all
      break
      ;;
    7)
      check_status
      ;;
    8)
      print_info "Goodbye!"
      exit 0
      ;;
    *)
      print_error "Invalid option. Please try again."
      ;;
    esac
  done
}

# Run main function with all arguments
main "$@"
