# Gitapper

Git is a difficult program to master because it can do a lot of things and often everyone needs to adapt it to their daily needs, with custom aliases and scripts.
This tool creates a wrapper to the `git` command that will let you extend it with custom scripts ([to execute before and after the real git command](#hooks-scripts-avalaible)).

The tool is based on other projects, [the first inspiration for bash wrapper](https://gist.github.com/mmueller/7286919) and [GrumPHP for their tasks system](https://github.com/phpro/grumphp) or [hub](https://hub.github.com/) that extend `git` with a lot of stuff.

It integrates natively [Forgit](https://github.com/wfxr/forgit) for various commands in case no file or branch are defined.

For a blogpost explaination check [here](https://daniele.tech/2021/09/gitapper-or-a-way-to-extend-git-without-alias-or-custom-scripts/).

## Showcase
![Show gif here](https://github.com/Mte90/gitapper/blob/master/showcase_gitapper.gif?raw=true)

## Requirements

* git
* bash
* wget
* [fzf](https://github.com/junegunn/fzf)

### Installation

```
git clone https://github.com/Mte90/gitapper
cd gitapper
# Download the bash dependencies
./build.sh

# on your .bashrc
alias git=/your/path/where/you/downloaded/gitapper
```

### Gitapper parameters

```
--nw    (As last command) Disable gitapper and pass all the parameters to the real git
--n    (As last command) Disable gitapper and pass -n parameter to the real git (integration with GrumPHP)
```

## Hooks

This bash script can run a specific script before and after the `git` command itself (or stop the execution of `git`).  
In this repository you can find various hooks with different requirements and usage on various commands.

### Hooks scripts avalaible

* Post-Clone
  * Auto-change directory inside the repo directory after cloning
  * Execute pip, npm or composer if the project use it
* Pre-Add
  * If no file passed, it will use the Forgit add with FZF
* Pre-Checkout
  * Like [hub](https://hub.github.com/), when the branch is a GitHub pull request URL it automatically create a new branch with that content
  * Branch picker when no branch is passed will use Forgit with FZF
* Pre-Clean
  * If no file is passed, it will use the Forgit clean with FZF
* Pre-Commit
  * Validate the commit if the `-m` parameter is defined following [ConventionalCommits](https://www.conventionalcommits.org/en/v1.0.0)
  * Add the music played from VLC, inspired from [https://github.com/mroth/git-muzak](https://github.com/mroth/git-muzak)
* Pre-Diff
  * If no file is passed, it will use the Forgit diff with FZF
* Pre-Log
  * If a file is passed, it will use the Forgit log with FZF
* Pre-Rebase
  * If used with interactive parameter, it will use the Forgit rebase with FZF
* Pre-Reset
  * If no file is passed, it will use the Forgit reset with FZF

### New commands avalaible

* `git commit rename` it will use amend internally
* `git commit remove [number]` it will remove the last commit based on `[number]`
* `git restage rename` it will update the index
* `git rename-branch` it will use [this script](https://github.com/tj/git-extras/blob/master/bin/git-rename-branch) from Git-Extras [licensed as MIT](https://github.com/tj/git-extras/blob/master/LICENSE) using the `build.sh` script
* `git squash [number]` it will merge all the commits based on that number starting from the latest
* `git fork [repo]` it will download from GitHub the original repo and configure your fork origin as upstream

## Autocomplete support

You can use [complete-alias](https://github.com/cykerway/complete-alias), that is a bash utility to add autocomplete to aliases, in [this way](https://github.com/Mte90/dotfiles/commit/8ace8602bb8d34f9e48cfd0220c1e3a6b3d5bee0) for the `git` command.

### Why is it different from an alias?

An alias is another command to remember, it is an external command, it does not extend another one.


### Verifying code style

This project is built with bash and Python for Linux. In order to fully approve this code's syntax use [shellcheck](https://github.com/koalaman/shellcheck) and [pylint](https://pypi.org/project/pylint/).
