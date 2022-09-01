# Download a GtiHub fork and add the upstream with the parameter --fork

# Requirements
#  - jq
#  - awk
set -- $*

url=$3
url=${url%/}
re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"
if [[ $url =~ $re ]]; then
        protocol=${BASH_REMATCH[1]}
        separator=${BASH_REMATCH[2]}
        hostname=${BASH_REMATCH[3]}
        user=${BASH_REMATCH[4]}
        repo=${BASH_REMATCH[5]}
        repo=${repo/\.git/}

        echo "$url download in progress"
        $GIT clone "git@github.com:$user/$repo.git" &> /dev/null
        cd $repo
        remote=$(curl -s "https://api.github.com/repos/$user/$repo" | jq -r '.parent.clone_url' | tail -c +20)
        if [ "$remote" != "" ]; then
            echo "$remote download in progress"
            $GIT remote add upstream "git@github.com:$remote" &> /dev/null
            $GIT fetch --all &> /dev/null
            exit 1
        fi
fi
