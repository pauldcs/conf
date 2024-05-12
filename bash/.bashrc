#!/bin/bash

#shopt -s checkwinsize
#shopt -s autocd

# /*------------------------------------------------------------*/
# /*--- Default                                              ---*/
# /*------------------------------------------------------------*/

export EDITOR=hx
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/opt/metasploit-framework/bin:$PATH

export HISTSIZE=1000000
export HISTFILESIZE=1000000000

export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

 Cyan='\033[1;36m'
Green='\033[1;32m'
  Red='\033[1;31m'
 Blue='\033[1;34m'
Reset='\033[0m'

#PS1="$Cyan\u$Reset @\h $Green\w$Reset $ "
PS1="$Cyan\u$Reset @\h $Green\w$Reset [\j]\n$ "
# /*------------------------------------------------------------*/
# /*--- Aliases                                              ---*/
# /*------------------------------------------------------------*/

alias     e="\${EDITOR:-vi}"
alias    ee="\${EDITOR:-vi} ."
alias    ll='ls -alFh --color'
alias    ls='ls -lFa --color'
alias    la='ls -Ah --color'
alias     l='ls -CF --color'
alias    c.='cd -'
alias    ..='cd ..'
alias   c..='cd ../..'
alias  c...='cd ../../..'
alias c....='cd ../../../..'
alias c....='cd ../../../..'
alias  cate="open -a TextEdit"
alias  path='echo $PATH | tr ":" "\n" | nl'
alias ghidra="/Users/pducos/lib/ghidra/ghidraRun"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs="clear; git status"
alias "::"="clear && "
# /*------------------------------------------------------------*/
# /*--- Functions                                            ---*/
# /*------------------------------------------------------------*/

function stamp() {
#
# DESCRIPTION
#         Add a header to files
#
    [[ $# -lt 1 ]] \
        && printf >&2 "Usage: stamp <file_name>\n" \
        && return 1

    [[ ! -f "$*" ]] \
        && printf >&2 " - No such file or directory\n" \
        && return 1

    [[ $(uname) == 'Linux' ]] \
        && {
                local tmp_file="$(mktemp)"
                local  time_up="$(stat -c '%y' "$@")"
            }

    [[ $(uname) == 'Darwin' ]] \
        && {
                local tmp_file="$(mktemp)"
                local  time_up="$(stat -f '%Sa' "$@")"
            }

 << __EOF__ cat > "$tmp_file"
/*---  $(printf "%-40s%40s  ---*/"                 "" "$(cksum "$@")")
/*---  $(printf "%-40s%40s  ---*/"                              "" "")
/*---  $(printf      "%80s  ---*/"                                 "")
/*---  $(printf      "%80s  ---*/"   "Updated: $time_up by $(whoami)")

__EOF__

    grep -m 1 "/*--- " "$@" &> /dev/null   \
        && sed -n '6,$p' "$@" >> "$tmp_file" \
        || cat "$@" >> "$tmp_file"

    # we cat the original file before overwriting it with the stamped one to
    # prevent any permanent losses in the case of a bug
    cat "$@"

    cat "$tmp_file" > "$@"
    rm "$tmp_file"
}

function strgrep() {
# 
# DESCRIPTION
#        Searches for <pattern> in files ending in
#	 	 <suffix> in the current directory + subdirectories
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
        --include \*"$suffix"              \
        -e "$pattern" "$@" . 2>/dev/null \
            ||  {
                    [[ $? -eq 1 ]]                          \
                        && >&2 printf " - No match found\n" \
                        || >&2 printf " + Grep returned %d\n" $?
                }
}

#function command_not_found_handle()
#{
#
#}

# retarded web dev thing
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
