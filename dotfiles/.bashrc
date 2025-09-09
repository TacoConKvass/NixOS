PS1="\n⎧ taco ❱ \[$(tput setaf 104)\]\w \[$(tput sgr0)\]\n⎩ $ "
function lastcommand {
    history | tail -1 | cut -c 8-
}

function deleteprompt {
    n=${PS1@P}
    n=${n//[^$'\n']}
    n=${#n}
    tput cuu $((n + 1))
    tput ed
}

PS0='\[$(deleteprompt)\]$ $(lastcommand)\n\[${PS1:0:$((EXPS0=1,0))}\]'
PROMPT_COMMAND='[ "$EXPS0" = 0 ] && deleteprompt && echo -e "$" || EXPS0=0'

alias ls="ls --color=auto"
