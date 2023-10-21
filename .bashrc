#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

################################################################################
# variables ->
export EDITOR=nvim
export VISUAL=subl
# <- variables
################################################################################
# alias & functions -->
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias cdd='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias ll='exa -la --group --group-directories-first'
alias catt='bat'
alias vim=nvim
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias sb=subl

burn-iso() {
    if [ "$#" -ne 2 ]; then
        echo "usage: ${FUNCNAME[0]} <path-to-iso> <device>"
        echo "example: ${FUNCNAME[0]} ~/my-iso.iso /dev/sdd"
        echo "check devices: sudo fdisk -l"
    else
        sudo dd if=$1 of=$2 bs=4M conv=fsync oflag=direct status=progress
    fi
}

sbf() {
    local files=$(fzf -m --preview 'bat --style=numbers --color=always --line-range :500 {}')
    if [ ! -z "$files" ]
    then
        subl $files
    fi
}

# <-- alias & functions
################################################################################
# PS1 -->
source ~/sources/git/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
__build-ps1() {
    local fgBlack='\[\033[01;30m\]'
    local fgGreen='\[\033[01;32m\]'
    local fgYellow='\[\033[01;33m\]'
    local fgBlue='\[\033[01;34m\]'

    local bgYellow='\[\033[01;43m\]'
    local bgGreen='\[\033[01;42m\]'
    local bgBlue='\[\033[01;44m\]'

    local colorReset='\[\033[0m\]'

    declare -A values
    declare -A prefixes
    declare -A bg
    declare -A fg

    local order=("path" "git" )

    values['path']="${PWD/$HOME/' '}"
    bg['path']=$bgBlue
    fg['path']=$fgBlue

    values['git']=$(__git_ps1 "%s")
    prefixes['git']='  '
    bg['git']=$bgYellow
    fg['git']=$fgYellow

    local splitter=''
    local result=''
    local prev=''
    for key in "${order[@]}"; do
        if [ -z "${values[$key]}" ]; then            
            continue
        fi
        
        if [ -z "$prev" ]; then
            result="${fgBlack}${bg[$key]} ${prefixes[$key]}${values[$key]}"
        else
            result="$result${fg[$prev]}${bg[$key]}$splitter"
            result="$result${fgBlack}${bg[$key]}${prefixes[$key]}${values[$key]}"
        fi
        prev=$key
    done
    result="$result$colorReset${fg[$prev]}$splitter$colorReset "
    echo "$result"
}

set_bash_prompt(){
    PS1="$(__build-ps1)"
}

PROMPT_COMMAND=set_bash_prompt
# <-- ps1
################################################################################
# sources -->

source ~/sources/git/contrib/completion/git-completion.bash

export FZF_DEFAULT_COMMAND='find .'
export FZF_DEFAULT_OPTS='-i --color=hl:#00ff00,hl+:#00ff00 --height 50% --border'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

# <-- sources
################################################################################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
