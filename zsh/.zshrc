# Use emacs-style keymap (gives you Ctrl-A / Ctrl-E, etc.)
bindkey -e

# Map Alt+Arrow sequences (what your terminal sends)
bindkey '^[[1;3D' backward-word   # Alt + ←
bindkey '^[[1;3C' forward-word    # Alt + →

# Also support some terminals' alternate code for Alt+←
bindkey '^[OD' backward-word

# Backward delete a line
bindkey \^U backward-kill-line

# Smart right arrow: accepts the whole autosuggestion if visible, else moves cursor.
# Binds both escape sequences terminals use for → (xterm normal + application cursor mode).
_autosuggest_or_forward() {
    if [[ -n "$POSTDISPLAY" ]]; then
        zle autosuggest-accept
    else
        zle forward-char
    fi
}
zle -N _autosuggest_or_forward
bindkey '^[[C' _autosuggest_or_forward   # → xterm normal mode
bindkey '^[OC' _autosuggest_or_forward   # → application cursor mode

# ↑ opens fzf history search, pre-filtered by whatever is already typed in the buffer.
# Escape cancels without changing the buffer; Enter accepts the selected command.
_history_fzf() {
    local selected
    selected=$(
        fc -rln 1 |
        awk '!seen[$0]++' |
        fzf --query "$BUFFER" \
            --no-sort \
            --prompt=' history  ' \
            --height=~40% \
            --border=rounded
    )
    if [[ -n "$selected" ]]; then
        BUFFER="$selected"
        CURSOR=${#BUFFER}
    fi
    zle reset-prompt
}
zle -N _history_fzf
bindkey '^[[A' _history_fzf   # ↑ xterm normal mode
bindkey '^[OA' _history_fzf   # ↑ application cursor mode

# Exclude / and . from word characters so Alt+Arrow stops at path segments and file extensions
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# Homebrew (Linux only — macOS sets this up automatically via /etc/zprofile)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# === Zsh History Settings ===
HISTFILE=~/.zsh_history           # Where history is saved
HISTSIZE=10000                    # Number of commands in memory
SAVEHIST=10000                    # Number of commands saved to file

setopt INC_APPEND_HISTORY         # Append to history immediately, not just at logout
setopt SHARE_HISTORY              # Share history across terminals
setopt HIST_IGNORE_DUPS          # Don't record duplicate commands
setopt HIST_REDUCE_BLANKS        # Remove extra spaces

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#ff9e64'   # Tokyo Night orange

setopt interactivecomments transientrprompt

# ===== Load Plugins in Correct Order =====
# zsh-syntax-highlighting MUST be sourced last.
# fzf-tab MUST come after compinit (provided by zsh-completions) and before syntax-highlighting.
source ~/.zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
autoload -Uz compinit && compinit
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ===== Theme =====
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    _OMP_CONFIG="$(brew --prefix oh-my-posh)/themes/negligible.omp.json"
  else
    _OMP_CONFIG="${HOME}/.local/share/oh-my-posh/themes/half-life.omp.json"
  fi
  eval "$(oh-my-posh init zsh --config "$_OMP_CONFIG")"
  unset _OMP_CONFIG
fi

# Alias
alias ls='eza'
alias ll='eza -l --git'
alias la='eza -a'
alias lla='eza -la --git'

# GPG
export GPG_TTY=$(tty)

# Banner — Tokyo Night gradient: blue → purple → pink
clear
_b1=$'\033[1;38;2;122;162;247m'
_b2=$'\033[1;38;2;157;140;247m'
_b3=$'\033[1;38;2;187;121;247m'
_b4=$'\033[1;38;2;217;102;232m'
_b5=$'\033[1;38;2;247;83;207m'
_b6=$'\033[1;38;2;247;118;142m'
_br=$'\033[0m'

echo "
${_b1} __     ______  _    _            _____  ______   _    _ ______ _____   ____  _ ${_br}
${_b2} \ \   / / __ \| |  | |     /\   |  __ \|  ____| | |  | |  ____|  __ \ / __ \| |${_br}
${_b3}  \ \_/ / |  | | |  | |    /  \  | |__) | |__    | |__| | |__  | |__) | |  | | |${_br}
${_b4}   \   /| |  | | |  | |   / /\ \ |  _  /|  __|   |  __  |  __| |  _  /| |  | | |${_br}
${_b5}    | | | |__| | |__| |  / ____ \| | \ \| |____  | |  | | |____| | \ \| |__| |_|${_br}
${_b6}    |_|  \____/ \____/  /_/    \_\_|  \_\______| |_|  |_|______|_|  \_\\____/(_)${_br}
"
unset _b1 _b2 _b3 _b4 _b5 _b6 _br

# Check if the constants file exists before sourcing to prevent startup errors
if [[ -f ~/.zsh_constants ]]; then
    source ~/.zsh_constants
fi

# Source the .zprofile
if [[ -f ~/.zprofile ]]; then
    source ~/.zprofile
fi

# Pyenv
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

export PATH="$HOME/.local/bin:$PATH"
