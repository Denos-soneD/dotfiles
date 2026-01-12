#!/bin/zsh

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
      dpkg -l "$1" 2>/dev/null | grep -q "^ii"
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

# Setup system locale
setup_locale() {
  case "$OS" in
    arch)
      print_header "Setting up System Locale"

      # Check if en_US.UTF-8 locale is available
      if ! locale -a | grep -q "en_US.utf8"; then
        print_info "Generating en_US.UTF-8 locale..."

        # Uncomment en_US.UTF-8 in /etc/locale.gen
        sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

        # Generate locale
        sudo locale-gen

        # Set system locale
        echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf

        print_status "Locale configured"
      else
        print_status "en_US.UTF-8 locale already available"
      fi
      ;;
    ubuntu)
      print_header "Setting up System Locale"

      # Check if en_US.UTF-8 locale is available
      if ! locale -a | grep -q "en_US.utf8"; then
        print_info "Generating en_US.UTF-8 locale..."
        sudo locale-gen en_US.UTF-8
        sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
        print_status "Locale configured"
      else
        print_status "en_US.UTF-8 locale already available"
      fi
      ;;
  esac
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

  # Create ZSH config directory
  if ! dir_exists "$HOME/.config/zsh"; then
    print_info "Creating ZSH config directory..."
    mkdir -p "$HOME/.config/zsh"
    print_status "ZSH config directory created"
  fi

  # Set ZDOTDIR environment variable
  if ! grep -q "ZDOTDIR=" "$HOME/.zshenv" 2>/dev/null; then
    echo 'export ZDOTDIR="$HOME/.config/zsh"' >>"$HOME/.zshenv"
    print_status "ZDOTDIR set in .zshenv"
  fi
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
      arch|fedora|centos)
        ssh_service="sshd"
        ;;
      ubuntu)
        ssh_service="ssh"
        ;;
    esac

    if [ -n "$ssh_service" ]; then
      # Check if service exists first
      if ! systemctl list-unit-files | grep -q "^$ssh_service.service"; then
        print_info "SSH service ($ssh_service.service) not found on this system"
        print_info "SSH server may not be installed or may use a different service name"
        return
      fi

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

# Git Setup
install_git() {
  print_header "Setting up Git Configuration"

  # Install Git based on OS
  case "$OS" in
    arch)
      install_packages git
      ;;
    ubuntu)
      install_packages git
      ;;
    fedora)
      install_packages git
      ;;
    centos)
      install_packages git
      ;;
    macos)
      install_packages git
      ;;
  esac
  print_info "Git installed successfully"

  print_info "Installing diff-so-fancy..."
  if ! command -v diff-so-fancy &>/dev/null; then
    case "$OS" in
      arch)
        install_packages diff-so-fancy
        ;;
      ubuntu)
        # diff-so-fancy is not available in Ubuntu apt repos, install via npm or direct download
        if command -v npm &>/dev/null; then
          print_info "Installing diff-so-fancy via npm..."
          sudo npm install -g diff-so-fancy
        else
          print_info "Installing diff-so-fancy via snap..."
          if ! command -v snap &>/dev/null; then
            print_info "Installing snapd..."
            sudo apt update
            sudo apt install -y snapd
          fi
          print_info "Starting and enabling snapd service..."
          sudo systemctl start snapd
          sudo systemctl enable snapd
          print_info "Installing diff-so-fancy via snap..."
          sudo snap install diff-so-fancy
        fi
        ;;
      fedora)
        install_packages diff-so-fancy
        ;;
      centos)
        install_packages diff-so-fancy
        ;;
      macos)
        if ! command -v brew &>/dev/null; then
          print_info "Installing Homebrew..."
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install diff-so-fancy
        ;;
      *)
        print_error "diff-so-fancy installation not supported for this OS"
        exit 1
        ;;
    esac
    print_status "diff-so-fancy installed successfully"
  else
    print_status "diff-so-fancy is already installed"
  fi

  print_info "Git Initialization completed"
}

# OpenCode Setup
install_opencode() {
  print_header "Setting up OpenCode - AI Coding Agent"

  # Check if OpenCode is already installed
  if command -v opencode &>/dev/null; then
    print_status "OpenCode is already installed"
    return
  fi

  # Install OpenCode based on OS
  case "$OS" in
    arch)
      print_info "Installing OpenCode via AUR..."
      if command -v paru &>/dev/null; then
        paru -S --needed --noconfirm opencode-bin
      elif command -v yay &>/dev/null; then
        yay -S --needed --noconfirm opencode-bin
      else
        print_info "No AUR helper found, installing via npm..."
        if ! command -v npm &>/dev/null; then
          install_packages npm
        fi
        sudo npm install -g opencode-ai
      fi
      ;;
    ubuntu|debian)
      print_info "Installing OpenCode via npm..."
      if ! command -v npm &>/dev/null; then
        print_info "Installing Node.js and npm..."
        install_packages nodejs npm
      fi
      sudo npm install -g opencode-ai
      ;;
    fedora)
      print_info "Installing OpenCode via npm..."
      if ! command -v npm &>/dev/null; then
        print_info "Installing Node.js and npm..."
        install_packages nodejs npm
      fi
      sudo npm install -g opencode-ai
      ;;
    centos)
      print_info "Installing OpenCode via npm..."
      if ! command -v npm &>/dev/null; then
        print_info "Installing Node.js and npm..."
        install_packages nodejs npm
      fi
      sudo npm install -g opencode-ai
      ;;
    macos)
      print_info "Installing OpenCode via Homebrew..."
      if ! command -v brew &>/dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      brew tap sst/tap
      brew install sst/tap/opencode
      ;;
    *)
      print_error "OpenCode installation not supported for this OS"
      return 1
      ;;
  esac

  # Verify installation
  if command -v opencode &>/dev/null; then
    print_status "OpenCode installed successfully"
    print_info "Run 'opencode auth login' to configure your API credentials"
    print_info "Navigate to your project and run 'opencode' to get started"
  else
    print_error "OpenCode installation failed - command not found"
    return 1
  fi
}

install_zed() {
  print_header "Installing Zed Editor..."

  if command -v zed &>/dev/null; then
    print_status "Zed is already installed"
    return 0
  fi

  case $OS in
    "arch")
      # Arch has Zed in the official repos now
      sudo pacman -S --noconfirm zed
      ;;
    "macos")
      brew install --cask zed
      ;;
    *)
      # For Ubuntu, Debian, Fedora, etc., use the official script
      print_info "Downloading official Zed install script..."
      curl -f https://zed.dev/install.sh | sh

      # Ensure the binary path is available for the rest of the script
      export PATH=$HOME/.local/bin:$PATH
      ;;
  esac

  if command -v zed &>/dev/null; then
    print_status "Zed installed successfully"
  else
    print_error "Zed installation failed"
  fi
}

setup_zed_config() {
  print_header "Linking Zed Configuration..."
  
  # Ensure we know where the dotfiles are. 
  # If you run this script from inside the folder, $(pwd) works.
  DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
  ZED_CONFIG_DIR="$HOME/.config/zed"

  mkdir -p "$ZED_CONFIG_DIR"

  # Link settings.json (Fixing the name difference: setting.json -> settings.json)
  if [ -f "$DOTFILES_DIR/zed/setting.json" ]; then
    ln -sf "$DOTFILES_DIR/zed/setting.json" "$ZED_CONFIG_DIR/settings.json"
    print_status "Linked settings.json"
  else
    print_error "Could not find zed/setting.json in dotfiles folder"
  fi

  # Link keymap.json
  if [ -f "$DOTFILES_DIR/zed/keymap.json" ]; then
    ln -sf "$DOTFILES_DIR/zed/keymap.json" "$ZED_CONFIG_DIR/keymap.json"
    print_status "Linked keymap.json"
  fi
}

# Initialize stow
install_stow() {
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
}

# Main function
main() {
  check_root
  detect_os
  setup_locale

  print_header " Starting Dotfiles Setup 🚀"

  install_stow
  install_git
  install_ssh

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

  print_info "Applying stow configurations..."
  rm -rf "$HOME/.config/zsh" "$HOME/.config/atuin" "$HOME/.config/git" "$HOME/.config/ssh" 2>/dev/null || true
  cd "$HOME/dotfiles"
  stow .

  install_zsh
  install_neovim
  install_atuin
  install_opencode
  install_zed
  setup_zed_config

  if [ "$SHELL" != "/bin/zsh" ] && [ "$SHELL" != "$(which zsh)" ]; then
  print_info "Changing default shell to zsh..."

  # Get zsh path
  local zsh_path=$(which zsh)

  # Check if zsh is in /etc/shells
  if ! grep -q "^$zsh_path$" /etc/shells; then
    print_info "Adding zsh to /etc/shells..."
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi

  # Try common zsh paths
  if chsh -s /bin/zsh 2>/dev/null; then
    print_status "Shell changed to zsh (/bin/zsh)"
  elif chsh -s "$zsh_path" 2>/dev/null; then
    print_status "Shell changed to zsh ($zsh_path)"
  else
    print_error "Failed to change shell to zsh"
    print_info "You may need to manually run: chsh -s $(which zsh)"
  fi
  else
    print_status "Shell is already set to zsh"
  fi
  source ~/.config/zsh/.zshrc
  print_status "Dotfiles setup completed successfully!"
  source ~/.config/zsh/.zshrc
}

# Run main function
main
