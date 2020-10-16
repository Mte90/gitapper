# Gitapper

Git is a difficult program to master because can do a lot of things and often everyone needs to adapt to their daily needs, with custom alias and also scripts.  
The idea behind the project is to create a wrapper to the `git` command that will let you to extend it with custom scripts (to execute before and after the real git command).

The tool is based on other projects, [the first inspiration for bash wrapper](https://gist.github.com/mmueller/7286919) and [GrumPHP for their tasks system](https://github.com/phpro/grumphp) or [hub](https://hub.github.com/) that extend `git` with a lot of stuff.

### Why si different from alias?

An alias is another command to remember, is an external command and is not extending another one.

## Requirements

* git
* bash

## Installation

```
curl -o /usr/local/bin/gitapper https://git.io/JTqou && chmod 755 /usr/local/bin/gitapper
alias git=gitapper
```

### Parameters

```
--nw    (As last command) Disable gitapper and pass all the parameters to GIT
```

## Hooks

This bash script can run a specific script before and after the `git` command itself (or stop the execution of git itself).  
In this repository you can find various hooks with different requirements and usage on various commands.

Also let you to create custom parameters with commands inside git without bash alias.

### Hooks script avalaible

* Pre-Clone
  * If clone command has `--fork` parameter automatically will download the original and your fork with a origin upstream configured
* Post-Clone
  * Auto change directory inside the repo folder after the clone
* Pre-Checkout
  * Like [hub](https://hub.github.com/), when the branch is a GitHub pull request URL it automatically create a new branch with that content
  * Branch picker when no branch is defined using [FZF](https://github.com/junegunn/fzf)
* Pre-commit
  * Validate the commit if `-m` parameter is defined following [ConventionalCommits](https://www.conventionalcommits.org/en/v1.0.0)

## Autocomplete support

You can use [complete-alias](https://github.com/cykerway/complete-alias) that is a bash utility to add autocomplete to alias, in [this way](https://github.com/Mte90/dotfiles/commit/8ace8602bb8d34f9e48cfd0220c1e3a6b3d5bee0) for `git` command.