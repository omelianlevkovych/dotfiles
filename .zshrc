# Completion system
autoload -Uz compinit && compinit

alias lg='lazygit'
export PATH="$HOME/.local/bin:$PATH"

# Better history settings
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # Share history between terminals
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt INC_APPEND_HISTORY     # Add commands immediately to history

# Starship prompt
eval "$(starship init zsh)"

# Zsh plugins (cross-platform: Mac Homebrew and Fedora paths)
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # Mac (Homebrew) - hardcoded path to avoid $(brew --prefix) overhead
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # Fedora
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Better ls with eza
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git --header'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons --level=2'
alias l='eza -l --icons --group-directories-first --git'

# fzf - fuzzy finder (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
    # Mac (Homebrew) - hardcoded path to avoid $(brew --prefix) overhead
    source /opt/homebrew/opt/fzf/shell/completion.zsh
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif [[ -f /usr/share/fzf/shell/key-bindings.zsh ]]; then
    source /usr/share/fzf/shell/key-bindings.zsh
fi

# zoxide - smarter cd (use 'z' to jump to directories)
eval "$(zoxide init zsh)"
export PATH="$HOME/.cargo/bin:$PATH"
