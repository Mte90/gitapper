#!/usr/bin/env bash
set -e
# Debug mode
# set -x

PARAMETERS=''
for arg in "$@"
do
  #if an argument contains a white space, enclose it in double quotes and append to the list
  #otherwise simply append the argument to the list
  if echo $arg | grep -q " "; then
   PARAMETERS="$PARAMETERS \"$arg\""
  else
   PARAMETERS="$PARAMETERS $arg"
  fi
done
# Trim top/end trailing space
PARAMETERS=$(echo $PARAMETERS | sed -e 's/^[[:space:]]*//')
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Looks inside this folder for scripts to include as wrapper for the various commands
GITAPPER_HOOKS="$DIR/hooks"
GIT=$(which -a git | head -1)

source $DIR/lib/forgit.sh

function exec_hook() {
    command=($2)
    for EXT in "sh" "py"
    do
        if [[ -f "$GITAPPER_HOOKS/$1-${command[0]}.$EXT" ]]; then
            if [[ $EXT == "sh" ]]; then
                . "$GITAPPER_HOOKS/$1-${command[0]}.$EXT" "$GIT" "$2 $3"
            else
                "$GITAPPER_HOOKS/$1-${command[0]}.$EXT" "$GIT" "$2 $3"
            fi
        fi
    done
    
    if [[ $? -eq 1 ]]; then
        exit 1
    fi
}

if [ "$GIT" = "" ]; then
    echo "git executable not found"
    exit 1
fi

# General: Do not run hooks for --help or nw
if [[ "${PARAMETERS}" == *"--help"* || "${PARAMETERS}" == *"--nw"* || "${PARAMETERS}" == *"gitapper"* ]]; then
    ARGS=''
    ARG=''
    # Remove --nw parameter and pass to git
    for i in "$@"
    do
        if [[ $i =~ "[[:space:]]" || $i != *"--nw"* ]]
        then
            i2=\"$i\"
            ARG=$i
            if [[ $ARG == *" "* ]]
            then
                ARG=\"$i\"
            fi
            ARGS="$ARGS $ARG"
            i=$i2
        fi
    done
    PARAMETERS=$ARGS
    
    eval $GIT$PARAMETERS
else
    GIT_PARAMETERS=$PARAMETERS
    exec_hook "pre" "$PARAMETERS"
    eval "$GIT $GIT_PARAMETERS"
    exec_hook "post" "$GIT_PARAMETERS"
fi 
