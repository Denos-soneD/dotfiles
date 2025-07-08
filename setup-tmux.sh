#!/bin/bash

# 🔧 Advanced tmux installation and configuration script
# Usage: ./setup-tmux.sh

set -e

# Configuration
TMUX_CONFIG="$HOME/.config/tmux/.tmux.conf"
TMUX_PLUGINS_DIR="$HOME/.tmux/plugins"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🚀 TMUX SETUP SCRIPT 🚀                   ║"
    echo "║                Configuration and plugins                     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Plugin installation function
install_plugin() {
    local plugin_name="$1"
    local plugin_url="$2"
    local plugin_dir="$TMUX_PLUGINS_DIR/$plugin_name"
    
    if [ -d "$plugin_dir" ]; then
        print_warning "Plugin $plugin_name already present"
        cd "$plugin_dir"
        if git pull --quiet; then
            print_success "Plugin $plugin_name updated"
        else
            print_warning "Unable to update $plugin_name"
        fi
    else
        print_step "Installing $plugin_name..."
        if git clone --quiet "$plugin_url" "$plugin_dir"; then
            print_success "Plugin $plugin_name installed"
        else
            print_error "Failed to install $plugin_name"
            return 1
        fi
    fi
}

main() {
    print_header
    
    # Step 1: Prerequisites check
    print_step "Checking prerequisites..."
    
    if ! command -v tmux &> /dev/null; then
        print_error "tmux is not installed"
        echo "Recommended installation:"
        echo "  Ubuntu/Debian: sudo apt install tmux"
        echo "  macOS: brew install tmux"
        echo "  Arch: sudo pacman -S tmux"
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        print_error "git is not installed"
        exit 1
    fi
    
    print_success "Prerequisites OK (tmux $(tmux -V | cut -d' ' -f2), git $(git --version | cut -d' ' -f3))"
    
    # Step 3: Plugins directory
    print_step "Creating plugins directory..."
    mkdir -p "$TMUX_PLUGINS_DIR"
    print_success "Directory created: $TMUX_PLUGINS_DIR"
    
    # Step 4: Plugin installation
    print_step "Installing tmux plugins..."
    
    # TPM (Tmux Plugin Manager)
    install_plugin "tpm" "https://github.com/tmux-plugins/tpm"
    
    # Plugins from your configuration
    install_plugin "tmux-sensible" "https://github.com/tmux-plugins/tmux-sensible"
    install_plugin "vim-tmux-navigator" "https://github.com/christoomey/vim-tmux-navigator"
    install_plugin "catppuccin-tmux" "https://github.com/dreamsofcode-io/catppuccin-tmux"
    install_plugin "tmux-yank" "https://github.com/tmux-plugins/tmux-yank"
    
    # Permissions
    chmod +x "$TMUX_PLUGINS_DIR/tpm/tpm" 2>/dev/null || true
    chmod +x "$TMUX_PLUGINS_DIR/tpm/bin/"* 2>/dev/null || true
    
    print_success "All plugins installed!"
    
    # Kill any existing tmux sessions
    tmux kill-server 2>/dev/null || true
}

# Error handling
trap 'print_error "Script interrupted" && exit 1' INT TERM

# Execution
main "$@"
