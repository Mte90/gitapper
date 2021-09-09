# FZF picker to rebase interactive

# Requirements
#  - fzf
set -- $*

if [[ $3 == "-i" || $4 == "" ]]; then
    forgit::rebase
    exit 1
fi
