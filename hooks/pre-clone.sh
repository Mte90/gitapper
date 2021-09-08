# Download a GtiHub fork and add the upstream with the parameter --fork

# Requirements
#  - jq
#  - awk
set -- $*

url=$4
url=${url%/}
if [[ $3 == "--fork" ]]; then
    re="^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+)$"
    if [[ $url =~ $re ]]; then
        protocol=${BASH_REMATCH[1]}
        separator=${BASH_REMATCH[2]}
        hostname=${BASH_REMATCH[3]}
        user=${BASH_REMATCH[4]}
        repo=${BASH_REMATCH[5]}

        echo "$url download in progress"
        /usr/bin/git clone "git@github.com:$user/$repo.git" &> /dev/null
        cd $repo
        remote=$(curl -s "https://api.github.com/repos/$user/$repo" | jq -r '.parent.clone_url' | tail -c +20)
        echo "https://api.github.com/repos/$user/$repo"
        if [ "$remote" != "" ]; then
            echo "$remote download in progress"
            /usr/bin/git remote add upstream "git@github.com:$remote" &> /dev/null
            /usr/bin/git fetch --all &> /dev/null
        fi 
        exit 1
    fi
fi
