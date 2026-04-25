# =============================================================================
#  Ubuntu Linux Lab - zsh configuration
# =============================================================================

# --- oh-my-zsh --------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # using Starship instead

plugins=(
  git
  sudo
  docker
  colored-man-pages
  command-not-found
  extract
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

# --- History ----------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# --- Aliases ----------------------------------------------------------------
# eza (modern ls) — keeps real `ls` untouched for learning purposes
alias ll='eza -l  --icons --git --group-directories-first'
alias la='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias lta='eza --tree --level=3 --icons -a'

# Nicer defaults for common tools
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'

# Navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias h='history'
alias c='clear'
alias cls='clear'

# Safer defaults
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- Tool initialization ----------------------------------------------------
# zoxide — smarter cd (`z <partial-name>`)
eval "$(zoxide init zsh)"

# fzf keybindings & completion (Ctrl+R for history, Ctrl+T for files)
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && \
  source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && \
  source /usr/share/doc/fzf/examples/completion.zsh

# Starship prompt (must be near the end)
eval "$(starship init zsh)"

# --- Helper: show lab tips --------------------------------------------------
help-lab() {
cat <<'EOF'

  Ubuntu Linux Lab - quick reference
  ------------------------------------------------------------
  File listing     ll, la, lt, lta      (powered by eza)
  File viewing     bat <file>           (syntax-highlighted cat)
  Fast find        fd <pattern>         (better than find)
  Fast grep        rg <pattern>         (ripgrep)
  Fuzzy finder     fzf                  (Ctrl+R: history, Ctrl+T: files)
  Smart cd         z <partial-name>     (zoxide)
  Multiplexer      tmux                 (prefix is Ctrl+a)
  System monitor   htop
  Manual pages     man <command>
  This help        help-lab

  Workspace:       ~/workspace (synced to your Mac)
  Exit shell:      type 'exit' - container keeps running

EOF
}

# --- Welcome banner ---------------------------------------------------------
if [[ -o interactive ]] && [[ -z "$LAB_BANNER_SHOWN" ]]; then
cat <<'EOF'

  Ubuntu Linux Lab  (Ubuntu 24.04 LTS)
  ----------------------------------------
  Type  help-lab  for a quick command reference.

EOF
  export LAB_BANNER_SHOWN=1
fi
