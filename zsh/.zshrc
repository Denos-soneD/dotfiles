# ~~~~~~~~~~~~~ ENVIRONMENT ~~~~~~~~~


DISABLE_UPDATE_PROMPT=true
HISTFILE=~/.config/zsh/.zsh_history

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export VISUAL="nvim"


# ~~~~~~~~~~~~~ PATH ~~~~~~~~~~~~~~~~


export ZSH="$HOME/.oh-my-zsh"


# ~~~~~~~~~~~~~ THEME ~~~~~~~~~~~~~~~


ZSH_THEME=""

fpath+=($HOME/.oh-my-zsh/custom/pure)
autoload -U promptinit; promptinit
prompt pure


# ~~~~~~~~~~~~~ PLUGINS ~~~~~~~~~~~~~


plugins=(git fzf fzf-tab zsh-syntax-highlighting zsh-completions zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


# ~~~~~~~~~~~~~ KEYBIND ~~~~~~~~~~~~~


bindkey -e
bindkey '^[w' kill-region
bindkey 'jj' atuin-search
# bindkey "${terminfo[kcuu1]}" fzf-history-widget

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

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
