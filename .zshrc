# Path to oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# Path configuration.
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
#export GEMINI_API_KEY=$(security find-generic-password -a phsaurav -s gemini-api-key -w)
GOPATH=$HOME/go PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
PATH="$HOME/.amplify/bin:$PATH"
PATH="$HOME/.console-ninja/.bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export FVM_CACHE_PATH="$HOME/.fvm"
export PATH="$FVM_CACHE_PATH/default/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"


# Aliases.
alias ..='cd ..'
alias ...='cd ../..'
alias fp="fzf --preview=\"bat --color=always {}\""
alias hf='fc -rl 1 | fzf | sed "s/^[ ]*[0-9]*[ ]*//" | awk "{printf \"%s\", \$0}"'
alias fn='nvim $(fzf --preview="bat --color=always {}")'
alias py='python'
alias tf='terraform'
alias v='vim'
alias nv='nvim'
alias cl='clear'
alias vea='source venv/bin/activate'
alias ved='deactivate'
alias air='~/.air'
alias ga:='git add . && git commit -am '
alias gw="git worktree"
alias lg='lazygit'
alias lsh='lazyssh'
alias killp='kill $(lsof -ti:3000,3001,8080,5000,8000,3306)'
alias ld='lazydocker'
alias ta='tmux attach'
alias nman="man -P 'nvim +Man!'"
alias grep='grep --color=auto'
alias ssh='TERM=xterm-256color ssh'
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kd='kubectl describe'
alias kex='kubectl exec it'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias ka='kubectl apply -f'
alias kctx='kubectl config get-contexts'
alias kuse='kubectl config use-context'

# Alias Functions
wt() {
  if [[ -n "$1" ]]; then
    cd ".worktrees/$1"
  fi
}

# Curl aliases
get() { if [[ "$1" == "-b" ]]; then shift; for url in "$@"; do curl -s -H "Accept: application/json" "$url" | jq . | bat -l json; done; else for url in "$@"; do curl -s -H "Accept: application/json" "$url" | jq .; done; fi }
post() { if [[ "$1" == "-b" ]]; then shift; data="$1"; shift; for url in "$@"; do curl -s -X POST -H "Content-Type: application/json" -d "$data" "$url" | jq . | bat -l json; done; else data="$1"; shift; for url in "$@"; do curl -s -X POST -H "Content-Type: application/json" -d "$data" "$url" | jq .; done; fi }
alias download='curl --progress-bar -O'
alias health='curl -f -s -o /dev/null -w "%{http_code}\n"'

# Obsidian aliases.
alias oo='cd ~/obsidian-vault/'
alias or='nvim ~/obsidian-vault/inbox/*.md'
alias ou='cd $HOME/notion-obsidian-sync-zazencodes && node batchUpload.js --lastmod-days-window 5'

# Eza (Better ls)
alias ls="eza --icons=always"
alias lsa="eza --color=always --all --long --icons=always --no-time --no-user --no-filesize"
alias lst="eza --color=always --no-permissions --tree --level=2 --all --long --icons=always --no-time --no-user --no-filesize"
alias lst3="eza --color=always --no-permissions --tree --level=3 --all --long --icons=always --no-time --no-user --no-filesize"

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "jeffreytse/zsh-vi-mode"


# Load and initialise completion system
autoload -Uz compinit
compinit

# Vi mode configuration
ZVM_VI_INSERT_ESCAPE_BINDKEY="kj"

# Initialize cursor changes in vi mode
ZVM_CURSOR_STYLE_ENABLED=true   # Ensure this is true to enable cursor changes
ZVM_INSERT_MODE_CURSOR="\e[4 q" # Bar/beam cursor (insert mode)
ZVM_NORMAL_MODE_CURSOR="\e[2 q" # Block cursor (normal mode)
ZVM_OPPEND_MODE_CURSOR="\e[4 q" # Bar cursor for open (appending) mode

# Configure autosuggestions after plugins are loaded
function zvm_after_init() {
  bindkey '^s' autosuggest-toggle
  bindkey '^k' autosuggest-execute
  bindkey '^j' autosuggest-accept
  bindkey -s '^;' '^[f'
  # bindkey '^R' fzf-history-widget
}


export FZF_COMPLETION_TRIGGER='::'
# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# FZF theme (Ayu Mirage).
fg="#CBCCC6"
hl="#F28779"
fg_plus="#CBCCC6"
bg_plus="#1F2430"
hl_plus="#F28779"
info="#80D4FF"
prompt="#FFCC66"
pointer="#F29E74"
marker="#73D0FF"
spinner="#73D0FF"
header="#5CCFE6"

export FZF_DEFAULT_OPTS="--color=fg:${fg},hl:${hl},fg+:${fg},bg+:${bg_plus},hl+:${hl_plus},info:${info},prompt:${prompt},pointer:${pointer},marker:${marker},spinner:${spinner},header:${header}"
# Direnv log format.
export DIRENV_LOG_FORMAT=""

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANWIDTH=999
export LS_COLORS="di=1;33:fi=0;37:ln=1;36:ex=1;35:.*=1;32"
export BAT_THEME="Nord"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# Dart CLI completion.
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && source "$HOME/.dart-cli-completion/zsh-config.zsh" || true

# Better directory stack navigation
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# History improvements
HISTSIZE=10000
SAVEHIST=10000

# Initialize a flag for first run
typeset -g FIRST_PROMPT=1

precmd() {
  # Check if this is the first prompt
  if ((FIRST_PROMPT)); then
    FIRST_PROMPT=0
    return
  fi

  # Get the last command from history
  local last_cmd=$(fc -ln -1)
  # Trim whitespace
  last_cmd="${last_cmd## }"
  
  # Don't add newline if the last command was clear
  if [[ "$last_cmd" != "cl" ]]; then
    echo
  fi
}

source <(fzf --zsh)

eval "$(zoxide init zsh)"

eval "$(starship init zsh)"
#eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh.toml)"


eval "$(direnv hook zsh)"

function venv_prompt_override() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    PS1=$(echo "$PS1" | sed 's/(venv) //')
  fi
}

autoload -U add-zsh-hook
add-zsh-hook precmd venv_prompt_override

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
bindkey '^r' atuin-search

