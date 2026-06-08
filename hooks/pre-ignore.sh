#!/usr/bin/env bash
set -euo pipefail

set -- "$*"
shopt -s extglob

if [[ "${1%%*( )}" == "/usr/bin/git ignore" ]]; then
    shift
    PATTERN="$1"
    
    if [[ -z "$PATTERN" ]]; then
        echo "Usage: git ignore <pattern>"
        echo "  Adds the given file or folder to .gitignore"
        exit 1
    fi
    
    if [[ -d "$PATTERN" ]]; then
        IGNORE_RULE="${PATTERN}/"
    elif [[ -f "$PATTERN" ]]; then
        IGNORE_RULE="$PATTERN"
    else
        IGNORE_RULE="$PATTERN"
    fi
    
    [[ ! -f .gitignore ]] && touch .gitignore
    
    if grep -Fxq "$IGNORE_RULE" .gitignore; then
        echo "Pattern '$IGNORE_RULE' is already in .gitignore"
    else
        echo "$IGNORE_RULE" >> .gitignore
        echo "Added '$IGNORE_RULE' to .gitignore"
    fi
    
    shopt -u extglob
    exit 1
fi

shopt -u extglob
