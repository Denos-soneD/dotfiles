# ~~~~~~~~~~~~~ ENVIRONMENT ~~~~~~~~~

DISABLE_UPDATE_PROMPT=true
HISTFILE=~/.config/zsh/.zsh_history

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.atuin/bin:$PATH"

# ~~~~~~~~~~~~~ OH MY ZSH ~~~~~~~~~~~

export ZSH="$HOME/.oh-my-zsh"

# ~~~~~~~~~~~~~ THEME ~~~~~~~~~~~~~~~

ZSH_THEME=""

# ~~~~~~~~~~~~~ PLUGINS ~~~~~~~~~~~~~

plugins=(git fzf fzf-tab zsh-syntax-highlighting zsh-completions zsh-autosuggestions)

# Only source Oh My ZSH if we're in ZSH
if [ -n "$ZSH_VERSION" ]; then
    source $ZSH/oh-my-zsh.sh
else
    echo "Warning: This configuration is for ZSH only. Current shell: $0"
    return 1
fi

# ~~~~~~~~~~~~~ PURE PROMPT ~~~~~~~~~

# Check if Pure prompt exists before trying to load it
if [[ -d "$HOME/.oh-my-zsh/custom/pure" ]]; then
    fpath+=($HOME/.oh-my-zsh/custom/pure)
    autoload -U promptinit; promptinit
    prompt pure
else
    echo "Installing Pure prompt..."
    git clone https://github.com/sindresorhus/pure.git ~/.oh-my-zsh/custom/pure
    fpath+=($HOME/.oh-my-zsh/custom/pure)
    autoload -U promptinit; promptinit
    prompt pure
fi

# ~~~~~~~~~~~~~ KEYBIND ~~~~~~~~~~~~~

bindkey -e
bindkey '^[w' kill-region

# Only set up Atuin keybinding if Atuin is available
if command -v atuin >/dev/null 2>&1; then
    bindkey 'jj' atuin-search
fi

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':completion:*:descriptions' format '[%d]'

# ~~~~~~~~~~~~~ ALIAS ~~~~~~~~~~~~~~~

alias v='nvim'

fast_push() {
    local message=${*:-"Fast commit"}
    git add . && git commit -m "$message" && git push
}
alias fp=fast_push
alias c='clear'

# Update command based on OS
case "$(uname -s)" in
    Linux*)
        if [ -f /etc/debian_version ]; then
            alias update='sudo DEBIAN_FRONTEND=noninteractive apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y'
        elif [ -f /etc/arch-release ]; then
            alias update='yay -Syu --noconfirm'
        elif [ -f /etc/fedora-release ]; then
            alias update='sudo dnf update -y --assumeyes'
        fi
        ;;
    Darwin*)
        alias update='HOMEBREW_NO_AUTO_UPDATE=1 brew update && NONINTERACTIVE=1 brew upgrade --force'
        ;;
esac

# Initialize Atuin only if it's available
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi