#!/usr/bin/env bash

# Safety: strict error handling
set -euo pipefail

# FZF picker to add in case no file is passed

# Requirements
#  - fzf
set -- "$*"
shopt -s extglob

if [[ "${1%%*( )}" == "/usr/bin/git add" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/../lib/forgit.sh add
    shopt -u extglob
    exit 1
fi
