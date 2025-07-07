#!/bin/bash

# 🎨 Dotfiles Environment Setup - Multi-OS Automated Installation Script
# Made with ❤️ by Denos-soneD
# Supports: Arch Linux, Ubuntu/Debian, Fedora, CentOS/RHEL, macOS

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

# Detect operating system
detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v pacman &>/dev/null; then
      OS="arch"
      print_status "Arch Linux detected"
    elif command -v apt &>/dev/null; then
      OS="ubuntu"
      print_status "Ubuntu/Debian detected"
    elif command -v dnf &>/dev/null; then
      OS="fedora"
      print_status "Fedora detected"
    elif command -v yum &>/dev/null; then
      OS="centos"
      print_status "CentOS/RHEL detected"
    else
      print_error "Unsupported Linux distribution"
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    print_status "macOS detected"
  else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}

# Check if package is installed
is_package_installed() {
  case "$OS" in
    arch)
      pacman -Q "$1" &>/dev/null
      ;;
    ubuntu)
      dpkg -l "$1" &>/dev/null
      ;;
    fedora)
      dnf list installed "$1" &>/dev/null
      ;;
    centos)
      yum list installed "$1" &>/dev/null
      ;;
    macos)
      if command -v brew &>/dev/null; then
        brew list "$1" &>/dev/null
      else
        return 1
      fi
      ;;
    *)
      return 1
      ;;
  esac
}

# Check if directory exists
dir_exists() {
  [ -d "$1" ]
}

# Install packages based on OS
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
    
    case "$OS" in
      arch)
        sudo pacman -S --needed --noconfirm "${to_install[@]}"
        ;;
      ubuntu)
        sudo apt update
        sudo apt install -y "${to_install[@]}"
        ;;
      fedora)
        sudo dnf install -y "${to_install[@]}"
        ;;
      centos)
        sudo yum install -y "${to_install[@]}"
        ;;
      macos)
        if ! command -v brew &>/dev/null; then
          print_info "Installing Homebrew..."
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install "${to_install[@]}"
        ;;
      *)
        print_error "Package installation not supported for this OS"
        exit 1
        ;;
    esac
    
    print_status "Packages installed successfully"
  fi
}

# ZSH Setup
install_zsh() {
  print_header "Setting up ZSH Environment"

  # Install ZSH and dependencies based on OS
  case "$OS" in
    arch)
      install_packages zsh fzf
      ;;
    ubuntu)
      install_packages zsh fzf
      ;;
    fedora)
      install_packages zsh fzf
      ;;
    centos)
      install_packages zsh fzf
      ;;
    macos)
      install_packages zsh fzf
      ;;
  esac

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

  echo export ZDOTDIR="$HOME/.config/zsh" >>"$HOME/.zshenv"
}

# Neovim Installation
install_neovim() {
  print_header "Setting up Neovim Configuration"

  # Install Neovim and dependencies based on OS
  case "$OS" in
    arch)
      install_packages neovim luarocks git
      ;;
    ubuntu)
      install_packages neovim luarocks git
      ;;
    fedora)
      install_packages neovim luarocks git
      ;;
    centos)
      install_packages neovim luarocks git
      ;;
    macos)
      install_packages neovim luarocks git
      ;;
  esac

  print_info "First launch of Neovim will install plugins automatically"
}

# SSH Setup
install_ssh() {
  print_header "Setting up SSH Configuration"

  # Install OpenSSH based on OS
  case "$OS" in
    arch)
      install_packages openssh
      ;;
    ubuntu)
      install_packages openssh-client openssh-server
      ;;
    fedora)
      install_packages openssh openssh-server
      ;;
    centos)
      install_packages openssh openssh-server
      ;;
    macos)
      # SSH is pre-installed on macOS
      print_status "SSH is pre-installed on macOS"
      ;;
  esac

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

  # Set proper permissions
  chmod 600 "$HOME/.ssh/id_rsa" "$HOME/.ssh/id_ed25519" 2>/dev/null || true
  chmod 644 "$HOME/.ssh/id_rsa.pub" "$HOME/.ssh/id_ed25519.pub" 2>/dev/null || true
  chmod 600 "$HOME/.ssh/config" 2>/dev/null || true

  print_status "SSH permissions set correctly"

  # Enable and start SSH service (Linux only)
  if [[ "$OS" != "macos" ]]; then
    local ssh_service=""
    case "$OS" in
      arch|ubuntu|fedora)
        ssh_service="sshd"
        ;;
      centos)
        ssh_service="sshd"
        ;;
    esac

    if [ -n "$ssh_service" ]; then
      # Enable SSH service
      if systemctl is-enabled "$ssh_service.service" &>/dev/null; then
        print_status "SSH service already enabled"
      else
        print_info "Enabling SSH service..."
        sudo systemctl enable "$ssh_service.service"
        print_status "SSH service enabled"
      fi

      # Start SSH service
      if systemctl is-active "$ssh_service.service" &>/dev/null; then
        print_status "SSH service already running"
      else
        print_info "Starting SSH service..."
        sudo systemctl start "$ssh_service.service"
        print_status "SSH service started"
      fi
    fi
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
    case "$OS" in
      arch)
        install_packages stow
        ;;
      ubuntu)
        install_packages stow
        ;;
      fedora)
        install_packages stow
        ;;
      centos)
        install_packages stow
        ;;
      macos)
        install_packages stow
        ;;
    esac
    print_status "Stow installed"
  fi

  cd "$HOME/dotfiles"

  # Apply stow for each package
  print_info "Applying stow configurations..."

  stow .

  print_status "Stow initialization completed"
}

# Main function
main() {
  check_root
  detect_os

  print_header " Starting Dotfiles Setup 🚀"

  if ! command -v git &>/dev/null; then
    print_info "Installing git..."
    install_packages git
    print_status "Git installed"
  fi

  if ! dir_exists "$HOME/dotfiles"; then
    git clone git@github.com:Denos-soneD/dotfiles.git "$HOME/dotfiles"
  else
    print_info "Dotfiles directory already exists, checking for updates..."
    cd "$HOME/dotfiles"
    git fetch origin main
    if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
      print_info "Updates available, pulling latest changes..."
      git pull origin main
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
