#!/usr/bin/env bash

# FZF picker to log interactive of a file

# Requirements
#  - fzf
set -- "$*"
parameters=($1)

if [[ ${parameters[2]} != "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source "$DIR"/../lib/forgit.sh
    forgit::log
    exit 1
fi
