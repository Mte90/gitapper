#!/usr/bin/env bash

# FZF picker to add in case no file is passed

# Requirements
#  - fzf
set -- "$*"

parameter=$3
if [[ $parameter == "" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source "$DIR"/../lib/forgit.sh
    forgit::add
    exit 1
fi
