# ZSHRC

autoload -U colors && colors
autoload -Uz promptinit
autoload -Uz compinit


# Nice prompt :)
promptinit
setopt promptsubst
if [ "`id -u`" -eq 0 ]; then
   PROMPT="%{$fg[blue]%}%T%{$reset_color%} [ %{$fg[red]%}%n%{$reset_color%}@%{$fg[green]%}%M%{$reset_color%}%u %2~ ] %{$fg_bold[red]%}%#%{$reset_color%} "
else
   PROMPT="%{$fg[blue]%}%T%{$reset_color%} [ %{$fg[red]%}%n%{$reset_color%}@%{$fg[green]%}%M%{$reset_color%}%u %2~ ] %# "
fi
RPROMPT="%{$fg_no_bold[red]%}%(?,%b,[%?])%{$reset_color%}"


# History
setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
compinit
eval "$(dircolors -b)"
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

# Colors
if [ -x /usr/bin/dircolors ] ; then
   if [ -r ~/.dir_colors ] ; then
      eval "`dircolors ~/.dir_colors`"
   elif [ -r /etc/dir_colors ] ; then
      eval "`dircolors /etc/dir_colors`"
   else
      eval "`dircolors`"
   fi
fi

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

if [ -n $(command -v pygmentize) ]
then
   alias pcat='pygmentize -g'
fi

# Custom envvars
export EDITOR="vim"
export TERM="xterm-256color"

# Dirstackfile
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
   dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
   [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
   print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome
setopt pushdignoredups
setopt pushdminus

# Emacs keybindings
bindkey -e
bindkey '\e[4~' end-of-line
bindkey '\e[1~' beginning-of-line

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
