#!/usr/bin/env bash

# FZF picker to diff interactive

# Requirements
#  - fzf
set -- "$*"
if [[ $3 == "" ]]; then
    forgit::diff
    exit 1
fi
