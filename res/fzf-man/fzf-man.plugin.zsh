#!/usr/bin/env zsh

fzf-man-widget() {
    if [ -z "$@" ]
    then
        \man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r \man
    else
        \man $@
    fi
}
alias man='fzf-man-widget'
