#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Nice prompt
export PS1="\[\e[00;34m\]\A\[\e[0m\]\[\e[00;37m\] [ \[\e[0m\]\[\e[00;31m\]\u\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[00;32m\]\h\[\e[0m\]\[\e[00;37m\] \W ]\[\e[0m\] "

# Tip from https://www.reddit.com/r/archlinux/comments/41s1w4/what_is_your_favorite_one_liner_to_use/cz50y1m
ll ()
{
   /bin/ls -vFlq --color=yes --time-style=long-iso "$@" | sed "s/$(date +%Y-%m-%d)/\x1b[32m     TODAY\x1b[m/;s/$(date +'%Y-%m-%d' -d yesterday)/\x1b[33m YESTERDAY\x1b[m/"
}

# Add some aliases
alias ls='/bin/ls --color=auto -F'
alias la='ll -A'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
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
export PAGER="less"
export LESS="-FSRXI"

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

if [ -f ~/.bash_aliases ]; then
   . ~/.bash_aliases
fi
