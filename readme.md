# Gitapper

Git is a difficult program to master because can do a lot of things and often everyone needs to adapt to their daily needs, with custom alias and also scripts.  
The idea behind the project is to create a wrapper to the `git` command that will let you to use custom scripts as example when `git checkout` is used.

The tool is based on other projects, [the first inspiration](https://gist.github.com/mmueller/7286919) and [GrumPHP](https://github.com/phpro/grumphp) or [hub](https://hub.github.com/).

## Requirements

* git
* bash

## Installation

`wget `

### Parameters

```
--nw    (As last command) Disable gitapper and pass all the parameters to GIT
```

## Hooks

This bash script can run a specific script before and after the `git` command itself.  
In this repository you can find various examples with different requirements and usage.

Also let you to create custom parameters with commands inside git without bash alias.
