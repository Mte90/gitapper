#!/usr/bin/env bash

# FZF picker to reset interactive

# Requirements
#  - fzf
set -- "$*"

if [[ $3 == "" ]]; then
    forgit::reset::head
    exit 1
fi
