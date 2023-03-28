#!/usr/bin/env bash

# Download a GtiHub fork and add the upstream with the parameter --fork

# Requirements
#  - jq
#  - awk
set -- $*

url=($3)
url=${url%/}
re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"

if [[ $url =~ $re ]]; then
        user=${BASH_REMATCH[4]}
        repo=${BASH_REMATCH[5]}
        repo=${repo/\.git/}

        echo "$url download in progress"
        $1 clone "git@github.com:$user/$repo.git"
        cd $repo
        remote=$(curl -s "https://api.github.com/repos/$user/$repo" | jq -r '.parent.clone_url' | tail -c +20)
        if [ "$remote" != "" ]; then
            echo "$remote download in progress"
            $1 remote add upstream "git@github.com:$remote" &> /dev/null
            $1 fetch --all &> /dev/null
        fi
        $(dirname "$0")/post-clone.sh ${parameters[0]} ${parameters[1]} ${parameters[2]}
        $SHELL
        exit 1
fi
