setopt PROMPT_SUBST

function nix_prompt_info() {
  if [[ -n "$IN_NIX_SHELL" ]]; then
    echo "%{${fg[magenta]}%}[nix:$IN_NIX_SHELL]%{${reset_color}%} "
  fi
}

function shlvl_prompt_info() {
  if [[ "$SHLVL" -gt 1 ]]; then
    echo "%{${fg[yellow]}%}[shlvl:$SHLVL]%{${reset_color}%} "
  fi
}

PROMPT='[%*] %m $(nix_prompt_info)$(shlvl_prompt_info)%{${fg_bold[red]}%}:: %{${fg[green]}%}%3~%(0?. . %{${fg[red]}%}%? )%{${fg[blue]}%}»%{${reset_color}%} '

function preexec() {
  timer=$(($(date +%s%0N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    elapsed=$((($now-$timer)/1000))

    hours=$(($elapsed/3600))
    min=$(($elapsed/60))
    sec=$(($elapsed%60))
        if [ "$elapsed" -le 1 ]; then
            timer_show=""
        elif [ "$elapsed" -le 60 ]; then
            timer_show="$elapsed s"
        elif [ "$elapsed" -gt 60 ] && [ "$elapsed" -le 180 ]; then
            timer_show="$min min. $sec s."
        else
            if [ "$hours" -gt 0 ]; then
                min=$(($min%60))
                timer_show="$hours h. $min min. $sec s."
            else
                timer_show="$min min. $sec s."
            fi
        fi

    export RPROMPT="%F{cyan}${timer_show}%{$reset_color%}"
    unset timer
  fi
}
