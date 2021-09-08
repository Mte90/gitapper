# Auto cd after cloning
set -- $*

basename=$(basename $3)
folder=${basename%.*}
cwd=$(pwd)

if [[ -d "$cwd/$folder" ]]; then
    cd "$cwd/$folder"
    $SHELL
fi
