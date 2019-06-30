# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=~/.local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="/home/emil/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="random"
ZSH_THEME="gallifrey"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  docker
  git
  vi-mode
)

source $ZSH/oh-my-zsh.sh

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

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add
fi

# Random
alias uhk='~/Downloads/UHK.Agent-1.2.12-linux-x86_64.AppImage'
alias t='tree -I node_modules'
alias myip='curl -s icanhazip.com'
alias scode='code --user-data-dir="~/.vscode-root $1"'
alias keyboard='gkbd-keyboard-display -l se'
alias theme='source ~/.zshrc'
alias light='node ~/code/telldus/app.js $1'
alias x='xclip -selection clipboard'
alias findInFiles='grep -rnw "$1" -e "$2"'
alias v=vi

alias docker-up='docker-compose up'
alias docker-kill-all='docker kill $(docker ps -q)'
# alias docker-bash='docker exec -it $1 /bin/bash' 

# Servers
alias gosemojs='ssh root@188.166.67.186'
alias shoppinglist='ssh root@139.59.156.88'
alias pi='ssh pi@192.168.1.5'
alias piOutside='ssh pi@fantomen2.asuscomm.com -p 9090'

# Aliases for git
# alias g='git $1'
# alias ga='git add $1'
# alias gp='git push'
# alias gcmsg='git commit -m $1'
alias gstat='git status'
# alias gsuno='git status -uno'
alias graph='git log --all --decorate --oneline --graph'
alias gitSync='git pull -r && git push'

function docker-ssh() {
  container=$(docker ps -aqf "name=$1")
  echo "container=$container"

  # docker exec -it $container /bin/bash
  docker exec -it $container /bin/bash -c "[ -e /bin/bash] && /bin/bash || /bin/ash"
}

function ngrok() {
 ~/Downloads/ngrok http $1 -region eu -host-header="localhost:$1"
}

function rnd() {
 cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

function rnd2() {
 </dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c $1  ; echo
}

function update() {
 _ apt-get update
 _ apt-get upgrade
 _ apt-get dist-upgrade
}

function updatevscode() {
  # Download the latest stable version of VS Code and store it in a temporary location
  wget https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable -O /tmp/code_latest_amd64.deb

  # Now, install the newly downloaded VS Code
  sudo dpkg -i /tmp/code_latest_amd64.deb
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_CTRL_T_COMMAND="fd --type f"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/emil/code/file-uploading/lambda/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/emil/code/file-uploading/lambda/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/emil/code/file-uploading/lambda/node_modules/tabtab/.completions/sls.zsh ]] && . /home/emil/code/file-uploading/lambda/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/emil/code/file-uploading/lambda/node_modules/tabtab/.completions/slss.zsh ]] && . /home/emil/code/file-uploading/lambda/node_modules/tabtab/.completions/slss.zsh

export PATH=$PATH:/home/emil/.go/bin

export GOPATH=/home/emil/go

export PATH=$PATH:/home/emil/go/bin
