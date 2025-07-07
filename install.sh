#!/bin/bash

# 🎨 Dotfiles Environment Setup - Automated Installation Script
# Made with ❤️ by Denos-soneD

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Icons
CHECKMARK="✅"
CROSS="❌"
INFO="ℹ️"
ROCKET="🚀"

# Print colored output
print_status() {
  echo -e "${GREEN}${CHECKMARK} $1${NC}"
}

print_error() {
  echo -e "${RED}${CROSS} $1${NC}"
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

  echo export ZDOTDIR="$HOME/.config/zsh" >> "$HOME/.zshenv"
}

# Neovim Installation
install_neovim() {
  print_header "Setting up Neovim Configuration"

  # Install Neovim and dependencies
  install_packages neovim luarocks git

  print_info "First launch of Neovim will install plugins automatically"
}

# SSH Setup
install_ssh() {
  print_header "Setting up SSH Configuration"
  
  # Install OpenSSH
  install_packages openssh
  
  # Create SSH directory if it doesn't exist
  if ! dir_exists "$HOME/.ssh"; then
    print_info "Creating SSH directory..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    print_status "SSH directory created"
  else
    print_status "SSH directory already exists"
  fi
  
  # Generate SSH key if it doesn't exist
  if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    print_info "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N "" -q
    print_status "SSH key generated"
  else
    print_status "SSH key already exists"
  fi
  
  # Generate ED25519 key if it doesn't exist (more secure)
  if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    print_info "Generating ED25519 SSH key..."
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -q
    print_status "ED25519 SSH key generated"
  else
    print_status "ED25519 SSH key already exists"
  fi
  
  # Apply SSH config using stow
  if [ -f "$HOME/dotfiles/ssh/.ssh/config" ]; then
    print_info "Applying SSH configuration with stow..."
    cd "$HOME/dotfiles"
    stow -t ~ ssh
    print_status "SSH configuration applied"
  else
    print_info "SSH config file not found, skipping configuration"
  fi
  
  # Set proper permissions
  chmod 600 "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_ed25519" 2>/dev/null || true
  chmod 644 "$HOME/.ssh/id_rsa.pub" "$HOME/.ssh/id_ed25519.pub" 2>/dev/null || true
  chmod 600 "$HOME/.ssh/config" 2>/dev/null || true
  
  print_status "SSH permissions set correctly"
  
  # Enable SSH service
  if systemctl is-enabled sshd.service &>/dev/null; then
    print_status "SSH service already enabled"
  else
    print_info "Enabling SSH service..."
    sudo systemctl enable sshd.service
    print_status "SSH service enabled"
  fi
  
  # Start SSH service
  if systemctl is-active sshd.service &>/dev/null; then
    print_status "SSH service already running"
  else
    print_info "Starting SSH service..."
    sudo systemctl start sshd.service
    print_status "SSH service started"
  fi
  
  # Display public keys
  print_info "Your SSH public keys:"
  echo -e "${BLUE}RSA:${NC}"
  [ -f "$HOME/.ssh/id_rsa.pub" ] && cat "$HOME/.ssh/id_rsa.pub"
  echo -e "${BLUE}ED25519:${NC}"
  [ -f "$HOME/.ssh/id_ed25519.pub" ] && cat "$HOME/.ssh/id_ed25519.pub"
  
  print_status "SSH setup completed"
}

# Initialize stow
init_stow() {
  print_header "Initializing Stow for Dotfiles Management"
  if ! command -v stow &>/dev/null; then
    print_info "Installing stow..."
    install_packages stow
    print_status "Stow installed"
  fi

  cd "$HOME/dotfiles"
  
  # Apply stow for each package
  print_info "Applying stow configurations..."
  
  # Stow zsh configuration
  if [ -d "zshrc" ]; then
    stow -t ~ zshrc
    print_status "ZSH configuration stowed"
  fi
  
  # Stow neovim configuration  
  if [ -d "nvim" ]; then
    stow nvim
    print_status "Neovim configuration stowed"
  fi
  
  print_status "Stow initialization completed"
}

# Main function
main() {
  check_root
  check_arch

  print_header "🚀 Starting Dotfiles Setup 🚀"

  if ! dir_exists "$HOME/dotfiles"; then
    git clone git@github.com:Denos-soneD/dotfiles.git "$HOME/dotfiles"
  else
    print_info "Dotfiles directory already exists, checking for updates..."
    cd "$HOME/dotfiles"
    git fetch origin master
    if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/master)" ]; then
      print_info "Updates available, pulling latest changes..."
      git pull origin master
      print_status "Dotfiles updated successfully"
    else
      print_status "Dotfiles already up to date"
    fi
  fi
 
  install_zsh
  install_neovim
  install_ssh
  init_stow

  print_status "Dotfiles setup completed successfully!"
  print_info "Please restart your shell or run: source ~/.config/zsh/.zshrc"
}

# Run main function
main
