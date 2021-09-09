# Gitapper

Git is a difficult program to master because can do a lot of things and often everyone needs to adapt to their daily needs, with custom aliases and also scripts (for various needs).
This tool create a wrapper to the `git` command that will let you to extend it with custom scripts ([to execute before and after the real git command](#hooks-scripts-avalaible)).

The tool is based on other projects, [the first inspiration for bash wrapper](https://gist.github.com/mmueller/7286919) and [GrumPHP for their tasks system](https://github.com/phpro/grumphp) or [hub](https://hub.github.com/) that extend `git` with a lot of stuff.

Integrate natively [Forgit](https://github.com/wfxr/forgit) for various commands in case there are not files or branch defined.

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
```

## Hooks

This bash script can run a specific script before and after the `git` command itself (or stop the execution of git itself).  
In this repository you can find various hooks with different requirements and usage on various commands.

### Hooks scripts avalaible

* Post-Clone
  * Auto change directory inside the repo folder after the clone
* Pre-Add
  * If no file passed will use the Forgit add with FZF
* Pre-Checkout
  * Like [hub](https://hub.github.com/), when the branch is a GitHub pull request URL it automatically create a new branch with that content
  * Branch picker when no branch is passed will use Forgit with FZF
* Pre-Clean
  * If no file passed will use the Forgit clean with FZF
* Pre-Commit
  * Validate the commit if `-m` parameter is defined following [ConventionalCommits](https://www.conventionalcommits.org/en/v1.0.0)
* Pre-Diff
  * If no file passed will use the Forgit diff with FZF
* Pre-Log
  * If a file is passed will use the Forgit log with FZF
* Pre-Rebase
  * If is used with interactive parameter will use the Forgit rebase with FZF
* Pre-Reset
  * If no file is passed will use the Forgit reset with FZF

### New commands avalaible

* `git commit rename` it will use amend internally
* `git commit remove [number]` it will remove the last commit based on that number
* `git restage rename` it will update the index
* `git rename-branch` it will use [this script](https://github.com/tj/git-extras/blob/master/bin/git-rename-branch)
* `git squash [number]` it will merge all those commit based on that number from the latest
* `git fork [repo]` it will download from GitHub the original and your fork with a origin upstream configured

## Autocomplete support

You can use [complete-alias](https://github.com/cykerway/complete-alias) that is a bash utility to add autocomplete to alias, in [this way](https://github.com/Mte90/dotfiles/commit/8ace8602bb8d34f9e48cfd0220c1e3a6b3d5bee0) for `git` command.

### Why si different from an alias?

An alias is another command to remember, is an external command and is not extending another one.
