# Auto cd after cloning
# set -- $*

# basename=$(basename $3)
# folder=${basename%.*}
# cwd=$(pwd)

# if [[ -d "$cwd/$folder" ]]; then
#     cd "$cwd/$folder"
#     $SHELL
# fi

# Install dependencies if they exist, first checks if software is installed
# npm, package.json
if [[ -f "package.json" ]]; then
  if which node &> /dev/null
    then
        npm install
    else
        echo "[REQUIREMENT] Node not installed. Can't install Node dependencies"
    fi
fi

# pip, requirements.txt
if [[ -f "requirements.txt" ]]; then
  if which pip &> /dev/null
    then
        pip install -r requirements.txt
    else
        echo "[REQUIREMENT] pip not installed. Can't install python dependencies"
    fi
fi

# composer, composer.json
if [[ -f "composer.json" ]]; then
  if which composer &> /dev/null
    then
        composer.phar install
    else
        echo "[REQUIREMENT] composer not installed. Can't install composer dependencies"
    fi
fi