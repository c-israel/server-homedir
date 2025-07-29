if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi


#############################################################################

export PS1="[\[[35m\]\u\[[m\]@\[[32m\]\h \[[33;1m\]\w\[[m\]]\$ "
umask 022

#############################################################################

eval "`dircolors`"

#############################################################################

alias ..='cd ..'
alias ...='cd ../..'
alias s='ssh -l root'
alias psj='ps aux|grep java |cut -c-$(tput cols)'
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'


#############################################################################

export EDITOR="vim"

export HISTFILESIZE=99999999
export HISTSIZE=99999999
export HISTCONTROL="ignoreboth"
export HISTFILE=~/.bash_history

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_OPTS="--preview 'erd -I -y inverted --suppress-size -C force {}'"
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"


#############################################################################

HISTTIMEFORMAT="%Y-%m-%d %T "

function netps() { [ -z "${1// }" ] && echo Usage: netps PATTERN &&return 1; ps axo pid,cmd  |grep "$1" | awk '{print $1}' | while read PID; do echo; ps wwwwo pid=,cmd= $PID; netstat -tulpn |grep $PID ; done }
function portgrep() { [ -z "${1// }" ] && echo Usage: portgrep PORT && return 1; lsof -i ":$1" -sTCP:LISTEN -t | while read PID; do echo; ps wwo pid=,cmd= $PID; netstat -tulpn |grep $PID; done }

#############################################################################

. ~/.fzf-keybindings.bash
. ~/.local/share/bash-completion/completions/fzf # enable fuzzy completion

eval "$(starship init bash)"
