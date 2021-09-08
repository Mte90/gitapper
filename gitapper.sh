#!/usr/bin/env bash
set -e
# Debug mode
set -x

PARAMETERS=$*
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Looks inside this folder for scripts to include as wrapper for the various commands
GITAPPER_HOOKS="$DIR/hooks"
GIT=$(which -a git | head -1)

function exec_hook() {
    for EXT in "sh" "py"
    do        
        if [[ -f "$GITAPPER_HOOKS/$1-$2.$EXT" ]]; then
            if [[ $EXT == "sh" ]]; then
                . "$GITAPPER_HOOKS/$1-$2.$EXT" "$GIT" "$PARAMETERS"
            else
                "$GITAPPER_HOOKS/$1-$2.$EXT" "$GIT" "$PARAMETERS"            
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
    GIT_PARAMETERS=${PARAMETERS/" --fork"/''}
    exec_hook "pre" $PARAMETERS
    eval $GIT "$GIT_PARAMETERS"
    exec_hook "post" $GIT_PARAMETERS
fi 
