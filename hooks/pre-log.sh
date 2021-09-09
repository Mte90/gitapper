# FZF picker to log interactive of a file

# Requirements
#  - fzf
set -- $*
if [[ $3 != "" ]]; then
    forgit::log
    exit 1
fi
