#!/usr/bin/env zsh

fzf-autojump-widget() {
    if [ -z "$@" ]
    then
        __fzf_autojump_target=$(cat "$HOME/.local/share/autojump/autojump.txt"|sort -nr|cut -f2|fzf +s)
        cd "$__fzf_autojump_target"
    else
        cd $(autojump $@)
    fi
}
alias j='fzf-autojump-widget'
