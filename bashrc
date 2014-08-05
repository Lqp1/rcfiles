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

if [ -n $(command -v pygmentize) ]
then
   alias pcat='pygmentize -g'
fi

# Some envvars
export EDITOR="vim"
