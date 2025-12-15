
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# zmodload zsh/zprof

# Top of .zshrc
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# Smarter completion initialization
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

export EXPO_TOKEN=6A_uE5PEfDeUzRgX-Su7cd6v_Et7yegVxgcqdZPh 
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export GPG_TTY=$(tty)

function ghpr() {
  gh pr list --limit 100 --json number,title,updatedAt,author --template \
    '{{range .}}{{tablerow .number .title .author.name (timeago .updatedAt)}}{{end}}' |
    fzf --height 25% --reverse |
    cut -f1 -d ' ' |
    xargs gh pr checkout
}

renameGit () {
  git mv $1 tempname && git mv tempname $2 
}

export SKILL_ISSUE="not in this house."

alias pr='gh pr view -w'
alias repo='gh repo view -w'
alias restore='git restore --source=origin --staged --worktree --'
alias get='gl upstream main'
alias rose='arch -x86_64 /bin/zsh'
alias ls='colorls'
alias fusion='npx builder.io@"/users/samijaber/code/work/ai-services/dist/dev-tools" launch'

bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# https://github.com/puppeteer/puppeteer/issues/6622#issuecomment-787912758
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=`which chromium`


# https://www.typescriptlang.org/docs/handbook/configuring-watch.html
# https://blog.johnnyreilly.com/2019/05/typescript-and-high-cpu-usage-watch.html
# https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-8.html#better-directory-watching-on-linux-and-watchoptions
# Drops CPU from ~22% to near 0%
export TSC_WATCHFILE=UseFsEventsWithFallbackDynamicPolling

PIPENV_IGNORE_VIRTUALENVS=1

export HUSKY_SKIP_INSTALL=false

autoload zmv

kgrep () {
    if [ $# -eq 0 ]; then
        echo "No arguments provided"
        echo "provide port of service you wish to kill"
        exit 1
    fi

    sudo ps aux | grep $1 | awk '{print $2}' | xargs kill -9
}

kport () {
    if [ $# -eq 0 ]; then
        echo "No arguments provided"
        echo "provide port of service you wish to kill"
        exit 1
    fi
    echo "Killing process on port $1"
    sudo kill `sudo lsof -t -i:$1`
}

alias npm-exec='PATH=$(npm bin):$PATH'
alias grbu='grb @{u}'


# https://github.com/nodejs/node/issues/18889#issuecomment-367146079
# https://dev.to/marcel_cremer/a-simple-tip-to-improve-angulars-compilation-speed-5dm0
# env NODE_OPTIONS=--max_old_space_size=4096
# http://hackjutsu.com/2016/08/04/Difference%20between%20set,%20export%20and%20env%20in%20bash/
export NODE_OPTIONS=--max_old_space_size=4096

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="spaceship"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
#plugins=(python postgres pipenv terraform git brew node npm yarn gem rails ruby bundler rake asdf)
plugins=(git brew asdf)

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
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#eval "$(gulp --completion=zsh)"

ghub() {
git clone git@github.com:$1.git
directory=$(echo $1 | cut -d "/" -f 2)  
cd $directory
} 

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# hide gcloud version info
SPACESHIP_GCLOUD_SHOW="false"
SPACESHIP_PROMPT_ASYNC=false


SPACESHIP_PROMPT_ORDER=(
  time           # Time stamps section
  user           # Username section
  dir            # Current directory section
  host           # Hostname section
  git            # Git section (git_branch + git_status)
  package        # Package version
  node           # Node.js section
  gcloud         # Google Cloud Platform section
  exec_time      # Execution time
  line_sep       # Line break
  jobs           # Background jobs indicator
  exit_code      # Exit code section
  char           # Prompt character
)

SPACESHIP_PROMPT_ADD_NEWLINE="false"
SPACESHIP_PROMPT_SEPARATE_LINE="false"
#SPACESHIP_CHAR_SYMBOL="\uf0e7"
#SPACESHIP_CHAR_PREFIX="\uf296"
#SPACESHIP_CHAR_SUFFIX=(" ")
SPACESHIP_CHAR_COLOR_SUCCESS="yellow"
#SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true"
 
# heroku autocomplete setup
# HEROKU_AC_ZSH_SETUP_PATH=/Users/samijaber/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
#[[ -f /Users/samijaber/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh ]] && . /Users/samijaber/.config/yarn/global/node_modules/tabtab/.completions/yarn.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#colorls tab completion
#source $(dirname $(gem which colorls))/tab_complete.sh

#add rust cargos to path
export PATH="$PATH:$HOME/.cargo/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
alias lg='lazygit'

export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# must come after zplug usage
alias git=hub
#compctl -g '~/.itermocil/*(:t:r)' itermocil

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# unload nvm so that asdf takes over.
# keeps nvm around so it can be used when needed
#nvm unload


eval "$(direnv hook zsh)"

# pnpm
export PNPM_HOME="/Users/samijaber/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/samijaber/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/samijaber/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/samijaber/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/samijaber/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Shopify Hydrogen alias to local projects
alias h2='$(npm prefix -s)/node_modules/.bin/shopify hydrogen'

export PATH=$PATH:$HOME/.maestro/bin


[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# zprof
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/samijaber/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# bun completions
[ -s "/Users/samijaber/.bun/_bun" ] && source "/Users/samijaber/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"



# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
