# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/Users/phsaurav/.oh-my-zsh"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"



# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	vi-mode
	direnv
)

# function zvm_config() {
#   ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
#   ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
# }

# function zvm_after_init() {
#   zvm_bindkey viins '^j' autosuggest-accept
#   zvm_bindkey viins '^k' autosuggest-execute
#   zvm_bindkey viins '^l'
# }

# source /Users/phsaurav/\$\{ZSH_CUSTOM:-~/.oh-my-zsh/custom\}/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

source $ZSH/oh-my-zsh.sh
# source $(brew --prefix nvm)/nvm.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases
alias zconf="nv ~/.zshrc"
alias cn="cd ~/.config/nvim/"
alias pb="cd ~/Documents/Play_Ground/Blank/"
alias fp="fzf --preview=\"bat --color=always {}\""
alias hf='fc -rl 1 | fzf | sed "s/^[ ]*[0-9]*[ ]*//" | awk "{printf \"%s\", \$0}"'
alias fn='nvim $(fzf --preview="bat --color=always {}")'
alias ohmyzsh="mate ~/.oh-my-zsh"
alias py='python'
alias tf='terraform'
alias v='vim'
alias nv='nvim'
alias ms='/opt/homebrew/opt/mongodb-community/bin/mongod --config /opt/homebrew/etc/mongod.conf'
alias clear='clear && printf "\e[3J"'
alias cl='clear'
alias vea='source venv/bin/activate'
alias ved='deactivate'
alias rs='python manage.py runserver'
alias air='~/.air'
alias fsr='uvicorn main:app --reload'
alias g:='git commit -m '
alias ga:='git add . && git commit -am '
alias lg='lazygit'
alias killp= 'kill $(lsof -ti:3000,3001,8080,5000,8000,3306)'
alias ld='lazydocker'
alias ta='tmux attach'

# Obsidian
alias oo='cd ~/obsidian-vault/'
alias or='nvim ~/obsidian-vault/inbox/*.md'
alias ou='cd $HOME/notion-obsidian-sync-zazencodes && node batchUpload.js --lastmod-days-window 5'



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
bindkey '^s' autosuggest-toggle
bindkey '^k' autosuggest-execute
bindkey '^j' autosuggest-accept
bindkey -s '^;' '^[f'
bindkey -M viins 'kj' vi-cmd-mode
eval "$(pyenv init -)"

export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`
export PYENV_ROOT="/Users/phsaurav/.pyenv"
export PATH="$PATH:/Users/phsaurav/Utils/flutter/bin"
export PATH="/Users/phsaurav/.local/bin:$PATH"
export DIRENV_LOG_FORMAT=""
# export VI_MODE_SET_CURSOR=true
# bindkey -v
# Change cursor with vim mode
function zle-keymap-select () {
case $KEYMAP in
vicmd) echo -ne '\e[1 q';; # block
viins|main) echo -ne '\e[3 q';; # underscore
esac
}
zle -N zle-keymap-select
zle-line-init() {
echo -ne "\e[3 q"
}
zle -N zle-line-init
echo -ne '\e[3 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[3 q' ;} # Use beam shape cursor for each new prompt.

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
source <(fzf --zsh)



# export PATH=/usr/local/share/python:$PATH
# # Configuration for virtualenv
# export WORKON_HOME=$HOME/.virtualenvs
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenvt

# CodeWhisperer post block. Keep at the bottom of this file.
#[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"

PATH=~/.console-ninja/.bin:$PATH

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/phsaurav/.dart-cli-completion/zsh-config.zsh ]] && . /Users/phsaurav/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]
