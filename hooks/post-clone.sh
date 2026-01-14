#!/usr/bin/env bash
#
# Safety: strict error handling
set -euo pipefail

set -- "$*"
read -ra parameters <<< "$1"

# Check if we have at least 3 parameters (script, command, repo_url)
if [[ ${#parameters[@]} -ge 3 ]]; then
    basename=$(basename "${parameters[2]}")
    folder=${basename%.*}
    cwd=$(pwd)

    if [[ -d "$cwd/$folder" ]]; then
        cd "$cwd/$folder" || exit
        $SHELL
    fi
fi

# Install dependencies if they exist, first checks if software is installed
# npm package.json
if [[ -f "package.json" ]]; then
  if which npm &> /dev/null
    then
        npm install
    else
        echo "[REQUIREMENT] NPM not installed. Can't install Node dependencies"
    fi
fi

# pip requirements.txt
if [[ -f "requirements.txt" ]]; then
  if which pip &> /dev/null
    then
        python -m venv .venv
        pip install -r requirements.txt
    else
        echo "[REQUIREMENT] pip not installed. Can't install python dependencies"
    fi
fi

# composer composer.json
if [[ -f "composer.json" ]]; then
  if which composer &> /dev/null
    then
        composer install
    else
        echo "[REQUIREMENT] composer not installed. Can't install composer dependencies"
    fi
fi
