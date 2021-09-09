# FZF picker to clean interactive
# Requirements
#  - fzf
set -- $*
if [[ $3 == "" ]]; then
    forgit::clean
    exit 1
fi
