# /*---                             2022609147 4717 .bashrc  ---*/
# /*---                                                      ---*/
# /*---                                                      ---*/
# /*---             Created: Feb  7 22:39:52 2023 by pducos  ---*/
# /*---             Updated: Feb  7 23:14:16 2023 by pducos  ---*/

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

function stamp() {
# 
# DESCRIPTION
#         Add a custom header to files
# 
    [[ $# -lt 1 ]] \
        && printf >&2 "Usage: stamp <file_name>\n" \
        && return 1

    [[ ! -f "$@" ]] \
        && printf >&2 " - No such file or directory\n" \
        && return 1

    local time_cr=$(stat -f "%SB" $@)
    local time_up=$(stat -f "%Sa" $@)
    local creator=$(stat -f "%Su" $@)

    local file="$@"
    local temp_file="$(mktemp)"

    << EOF cat >> $temp_file
# /*---  $(printf "%50s  ---*/"                   "$(cksum $@)")
# /*---  $(printf "%50s  ---*/"                              "")
# /*---  $(printf "%50s  ---*/"                              "")
# /*---  $(printf "%50s  ---*/" "Created: $time_cr by $creator")
# /*---  $(printf "%50s  ---*/"    "Updated: $time_up by $USER")
EOF
    
    grep -m 1 "/*--- " $@ &> /dev/null  \
        && sed -n '6,$p' $@ >> $temp_file \
        || cat $@ >> $temp_file

    cat $temp_file > $@ 
    rm $temp_file
}

function strgrep() {
# 
# DESCRIPTION
#        Searches for <pattern> in files ending in <suffix> in the current directory,
# 
    [[ $# -lt 2 ]] \
        && printf >&2 "Usage: strgrep <suffix> <pattern> [<grep_options>]\n" \
        && return 1
    
    local suffix="$1"; shift
    local pattern="$1"; shift

    grep \
        -r                               \
        --color=auto                     \
        --exclude-dir={.git,.svn}        \
        --include \*$suffix              \
        -e "$pattern" "$@" . 2>/dev/null \
            ||  {
                    [[ $? -eq 1 ]]                          \
                        && printf >&2 " - No match found\n" \
                        || printf >&2 " + Grep returned $?\n"
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
            [ $# -ne 1 ] \
                && printf >&2 " - Missing argument\n" \
                && return 1

            printf "${1}\n" >> "$memo_file"
        ;;
        del)
            [ $# -ne 1 ] \
                && printf >&2 " - Missing argument\n" \
                && return 1

            memo="$(sed -n "${1}p" "$memo_file")"
            [ -z "$memo" ] \
                && printf >&2 " - Not found\n" \
                && return 1

            sed -i -n "${1}d" "$memo_file" \
                && printf >&2 " + Deleting '$memo'\n"
        ;;
        cp)
            [ $# -ne 1 ] \
                && printf >&2 " - Missing argument\n" \
                && return 1

            memo="$(sed -n "${1}p" "$memo_file")"
            [ -z "$memo" ] \
                && printf >&2 " - Not found\n" \
                && return 1

            printf "$memo" | pbcopy
            printf >&2 " + Copied\n"
        ;;
        *)
            nl "$memo_file"
        ;;
    esac
}

[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"
