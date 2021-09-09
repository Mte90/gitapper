# FZF picker to add in case no file is passed

# Requirements
#  - fzf
set -- $*

parameter=$3
if [[ $parameter == "" ]]; then
    forgit::add
    exit 1
fi
