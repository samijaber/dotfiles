# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# https://github.com/puppeteer/puppeteer/issues/6622#issuecomment-787912758
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=$(which chromium)

# https://www.typescriptlang.org/docs/handbook/configuring-watch.html
# https://blog.johnnyreilly.com/2019/05/typescript-and-high-cpu-usage-watch.html
# https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-8.html#better-directory-watching-on-linux-and-watchoptions
# Drops CPU from ~22% to near 0%
export TSC_WATCHFILE=UseFsEventsWithFallbackDynamicPolling

PIPENV_IGNORE_VIRTUALENVS=1

autoload zmv

kgrep() {
  if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "provide port of service you wish to kill"
    exit 1
  fi

  sudo ps aux | grep $1 | awk '{print $2}' | xargs kill -9
}

kport() {
  if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "provide port of service you wish to kill"
    exit 1
  fi
  echo "Killing process on port $1"
  sudo kill $(sudo lsof -t -i:$1)
}

# alias npm-exec='PATH=$(npm bin):$PATH'

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="spaceship"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
#plugins=(python postgres pipenv terraform git brew node npm yarn gem rails ruby bundler rake asdf)
plugins=(postgres git brew node npm yarn asdf)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
#export PATH=/usr/local/bin:/usr/local/sbin:$PATH
#export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
eval $(/opt/homebrew/bin/brew shellenv)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias pr='gh pr view -w'
alias repo='gh repo view -w'
alias restore='git restore --source=upstream/main --staged --worktree --'
alias get='gl upstream main'
alias rose='arch -x86_64 /bin/zsh'
alias ls='colorls'
alias lg='lazygit'

# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# hide gcloud version info
SPACESHIP_GCLOUD_SHOW="false"

#SPACESHIP_PROMPT_ORDER=()
SPACESHIP_PROMPT_ADD_NEWLINE="false"
SPACESHIP_PROMPT_SEPARATE_LINE="false"

# symbol breaks codewhisperer/fig autocompletion
SPACESHIP_ASYNC_SYMBOL=""

#SPACESHIP_CHAR_SYMBOL="\uf0e7"
#SPACESHIP_CHAR_PREFIX="\uf296"
#SPACESHIP_CHAR_SUFFIX=(" ")
SPACESHIP_CHAR_COLOR_SUCCESS="yellow"
#SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#add rust cargos to path
export PATH="$PATH:$HOME/.cargo/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

eval "$(direnv hook zsh)"

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"
