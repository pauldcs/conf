# /* pducos `.bashrc`
#  * Created: 37.02.2023
#  */

if [ -z "$PS1" ]; then
    return
fi

shopt -s checkwinsize

#	/*------------------------------------------------------------*/
#	/*--- Default                                              ---*/
#	/*------------------------------------------------------------*/

export EDITOR=hx
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

Cyan='\033[1;36m'
Green='\033[1;32m'
Red='\033[1;31m'
Blue='\033[1;34m'
Reset='\033[0m'

if [ $UID -ne 0 ];
    then
        PS1="$Cyan\u$Reset:$Green\W$Reset $SHELL % "
    else
        PS1="$Red\u$Reset:$Green\W$Reset $SHELL # "
fi

#	/*------------------------------------------------------------*/
#	/*--- Aliases                                              ---*/
#	/*------------------------------------------------------------*/

alias root='sudo bash'
alias home='cd ~'
alias "tree"="tree -C"
alias ll='ls -alFh --color'
alias ls='ls -lF --color'
alias la='ls -Ah --color'
alias l='ls -CF --color'
alias "e"="hx"
alias "ee"="hx ."
alias ..='cd ..'
alias c..='cd ../..'
alias c...='cd ../../..'
alias c....='cd ../../../..'

#	/*------------------------------------------------------------*/
#	/*--- Functions                                            ---*/
#	/*------------------------------------------------------------*/

function strgrep() {
# 
# DESCRIPTION
#        Searches for <pattern> in files ending in <suffix> in the current directory,
# 
    [[ $# -lt 2 ]] && \
        printf >&2 "Usage: strgrep <suffix> <pattern> [<grep options>]\n" && return 1
    local suffix="$1"; shift
    local pattern="$1"; shift
    grep \
        -r                        \
        --color=auto              \
        --exclude-dir={.git,.svn} \
        --include \*$suffix       \
        -e "$pattern" "$@" . 2>/dev/null \
            ||  {
                    [[ $? -eq 1 ]]                             \
                        && printf >&2 "No match found.\n"      \
                            || printf >&2 "- Grep returned $?\n"
                    return 1
                }
}

function memo() {
# 
# DESCRIPTION
#        memo is a bash function to manage a memo file stored in ~/.memo. Actions:
#            memo: Display memo file
#            memo add "text": Add a memo
#            memo del N: Delete memo at line N
#            memo cp N: Copy memo at line N to clipboard
# 
    local memo_file=~/.memo
    local action="$1"
    shift

    case "$action" in
        add)
            if [ $# -ne 1 ];
                then
                    printf >&2 " - error: Missing argument\n"
                    return 1
            fi
            printf "${1}\n" >> "$memo_file"
        ;;
        del)
            if [ $# -ne 1 ];
                then
                    printf >&2 " - error: Missing argument\n"
                    return 1
            fi
            memo="$(sed -n "${1}p" "$memo_file")"
            if [ -z "$memo" ];
                then
                    printf >&2 " - error: Not found\n"
                    return 1
            fi
            printf >&2 " + Deleting '$memo'\n"
            sed -i -n "${1}d" "$memo_file"
			  ;;
        cp)
            if [ $# -ne 1 ];
                then
                    printf >&2 " - error: Missing argument\n"
                    return 1
            fi
            memo="$(sed -n "${1}p" "$memo_file")"
            if [ -z "$memo" ];
                then
                    printf >&2 " - error: Not found\n"
                    return 1
            fi
            printf "$memo" | pbcopy
            printf >&2 " + Copied\n"
        ;;
        *)
            nl "$memo_file"
        ;;
    esac
}

[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"
