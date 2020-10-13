#!/usr/bin/env bash
set -e
# Debug mode
#set -x

set -- $*
PARAMETERS=$@
FIRSTPARAMETER=$PARAMETERS
# Looks inside this folder for scripts to include as wrapper for the various commands
GITAPPER_HOOKS=./hooks
GIT=$(which -a git)

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
if [[ "${@: -1}" == "--help" || "${@: -1}" == "--nw" ]]; then
    if [[ "${@: -1}" == "--nw" ]]; then
        PARAMETERS=${PARAMETERS::-5}
    fi
    "$GIT" "$@"
else
    exec_hook "pre" $FIRSTPARAMETER
    "$GIT" "$@"
    exec_hook "post" $FIRSTPARAMETER
fi 
