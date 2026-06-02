PS1="\n[$(tput setaf 33)\u$(tput sgr0)@$(tput setaf 35)\h$(tput sgr0)] \[$(tput setaf 104)\]\w \[$(tput sgr0)\]\n$ "
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

alias ls="ls --color=auto"
