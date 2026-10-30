typeset -U path cdpath fpath manpath
# oh-my-zsh extra settings for plugins

plugins=(docker git timer)

ZSH_THEME="robbyrussell"
source $HOME/.oh-my-zsh/oh-my-zsh.sh

HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="/home/brunofl/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK

# Enabled history options
enabled_opts=(
  HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
)
for opt in "${enabled_opts[@]}"; do
  setopt "$opt"
done
unset opt enabled_opts

# Disabled history options
disabled_opts=(
  APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS
  HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
)
for opt in "${disabled_opts[@]}"; do
  unsetopt "$opt"
done
unset opt disabled_opts

if [ -z "$TMUX" ]; then
    tmux attach || tmux
fi 

[ -f "/home/brunofl/.cache/wal/sequences" ] &&
    cat "/home/brunofl//.cache/wal/sequences"
[ -f "/home/brunofl//.cache/wal/colors-tty.sh" ] &&
    source /home/brunofl/.cache/wal/colors-tty.sh

source "/usr/share/fzf/key-bindings.zsh"
source "/usr/share/fzf/completion.zsh"

export TERM="screen-256color"
export EDITOR="vim"
eval $(ssh-agent) 2>&1 >/dev/null
ssh-add ~/.ssh/id_ykmain 2> /dev/null

export PATH="$HOME/.local/bin:$PATH"

export GPG_TTY=$TTY

alias -- ga='git add'
alias -- gap='git add -p'
alias -- gc='git commit'
alias -- gcp='git cherry-pick'
alias -- gs='git status'
alias -- ll='ls -l'


