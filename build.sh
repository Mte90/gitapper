#!/usr/bin/env bash

echo "Downloading Forgit"
wget https://raw.githubusercontent.com/wfxr/forgit/master/forgit.plugin.zsh -O ./lib/forgit.sh

echo "Downloading Git Extras"
wget https://github.com/tj/git-extras/raw/master/bin/git-rename-branch -O ./lib/rename-branch.sh
chmod +x ./lib/rename-branch.sh
