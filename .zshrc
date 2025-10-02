# Path to oh-my-zsh installation.
export GHOSTTY_RESOURCES_DIR="/Applications/Ghostty.app/Contents/Resources/ghostty"
source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty.zsh"
export ZSH="$HOME/.oh-my-zsh"

# Path configuration.
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Utils/flutter/bin:$PATH"
PATH="$HOME/.amplify/bin:$PATH"
PATH="$HOME/.console-ninja/.bin:$PATH"

# Ruby environment initialization.
#eval "$(rbenv init -)"

# ZSH Theme configuration.
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin configuration.
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  vi-mode
)

# Load oh-my-zsh.
#source $ZSH/oh-my-zsh.sh

# User configuration.
# Uncomment to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment to use hyphen-insensitive completion.
# HYPHEN_INSENSITIVE="true"

# Aliases.
alias zconf="nv ~/.zshrc"
alias dot="cd ~/dotfiles/"
alias cdb="cd ~/Documents/Play_Ground/Blank/"
alias fp="fzf --preview=\"bat --color=always {}\""
alias hf='fc -rl 1 | fzf | sed "s/^[ ]*[0-9]*[ ]*//" | awk "{printf \"%s\", \$0}"'
alias fn='nvim $(fzf --preview="bat --color=always {}")'
alias ohmyzsh="mate ~/.oh-my-zsh"
alias py='python'
alias tf='terraform'
alias v='vim'
alias nv='nvim'
alias ms='/opt/homebrew/opt/mongodb-community/bin/mongod --config /opt/homebrew/etc/mongod.conf'
alias cl='clear'
alias vea='source venv/bin/activate'
alias ved='deactivate'
alias rs='python manage.py runserver'
alias air='~/.air'
alias fsr='uvicorn main:app --reload'
alias g:='git commit -m '
alias ga:='git add . && git commit -am '
alias lg='lazygit'
alias killp='kill $(lsof -ti:3000,3001,8080,5000,8000,3306)'
alias ld='lazydocker'
alias ta='tmux attach'

# Obsidian aliases.
alias oo='cd ~/obsidian-vault/'
alias or='nvim ~/obsidian-vault/inbox/*.md'
alias ou='cd $HOME/notion-obsidian-sync-zazencodes && node batchUpload.js --lastmod-days-window 5'

# Prompt configuration.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autosuggestions bindkeys.
bindkey '^s' autosuggest-toggle
bindkey '^k' autosuggest-execute
bindkey '^j' autosuggest-accept
bindkey -s '^;' '^[f'
bindkey -M viins 'kj' vi-cmd-mode

# pyenv initialization.
eval "$(pyenv init -)"
# # Change cursor with vim mode.
# function zle-keymap-select() {
#   case $KEYMAP in
#     vicmd) echo -ne '\e[1 q';; # block
#     viins|main) echo -ne '\e[4 q';; # thicker underscore
#   esac
#
# zle -N zle-keymap-select
#
# zle-line-init() {
#   echo -ne "\e[4 q"
# }
# zle -N zle-line-init
#
# preexec() {
#   echo -ne "\e[4 q"
# }
echo -e '\e[0 q' 
bindkey '^R' fzf-history-widget

export FZF_CTRL_R_OPTS="
  --preview 'echo {2..} | bat --color=always -pl sh'
  --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-t:track+clear-query'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_COMPLETION_TRIGGER='**'

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
# pyenv root.
export PYENV_ROOT="$HOME/.pyenv"
# Direnv log format.
export DIRENV_LOG_FORMAT=""

# Eza (better ls) configuration.
alias ls="eza --icons=always"
alias lsa="eza --color=always --all --long --icons=always --no-time --no-user --no-filesize"
alias lst="eza --color=always --no-permissions --tree --level=2 --all --long --icons=always --no-time --no-user --no-filesize"
export LS_COLORS="di=1;33:fi=0;37:ln=1;36:ex=1;35:.*=1;32"
export BAT_THEME="gruvbox-dark"

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
setopt SHARE_HISTORY

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

eval "$(starship init zsh)"


