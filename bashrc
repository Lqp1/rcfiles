#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Nice prompt
export PS1="\[\e[00;34m\]\A\[\e[0m\]\[\e[00;37m\] [ \[\e[0m\]\[\e[00;31m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[00;32m\]\h\[\e[0m\]\[\e[00;37m\] \W ]\[\e[0m\] "

# Add some aliases
alias ls='ls --color=auto -F'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -l'
alias lla='ls -lA'
alias la='ls -A'
alias l='ls -C'
alias git-glog='git log --graph --pretty="format:%ad %C(yellow)%h%Creset - %C(red)%an%Creset : %C(bold blue)%d%Creset %s" --date=short --all'

command -v pygmentize > /dev/null
HAS_PYGMENTIZE=$?
if [ $HAS_PYGMENTIZE -eq 0 ]
then
   alias pcat='pygmentize -g'
fi

# Some envvars
export EDITOR="vim"
export TERM="xterm-256color"

# Colored man
man() {
   env LESS_TERMCAP_mb=$'\E[01;31m' \
      LESS_TERMCAP_md=$'\E[01;38;5;74m' \
      LESS_TERMCAP_me=$'\E[0m' \
      LESS_TERMCAP_se=$'\E[0m' \
      LESS_TERMCAP_so=$'\E[38;5;246m' \
      LESS_TERMCAP_ue=$'\E[0m' \
      LESS_TERMCAP_us=$'\E[04;38;5;146m' \
      man "$@"
}
