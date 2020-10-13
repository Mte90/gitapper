# Download a GtiHub fork and add the upstream with the parameter --fork

# Requirements
#  - jq
#  - awk
set -- $*

url=$4
url=${url%/}
if [[ $3 == "--fork" ]]; then
    if [[ $url == *"https://github.com/"* ]]; then
        echo "$url download in progress"
        git clone "git@github.com:$url.git" &> /dev/null
        user=$(echo "$url" | awk -F/ '{print $1}')
        repo=$(echo "$url" | awk -F/ '{print $NF}')
        cd $repo
        remote=$(curl -s "https://api.github.com/repos/$user/$repo" | jq -r '.parent.clone_url' | tail -c +20)
        if [ "$remote" != "" ]; then
            echo "$remote download in progress"
            git remote add upstream "git@github.com:$remote" &> /dev/null
            git fetch --all &> /dev/null
        fi 
        exit 1
    fi
fi

exit 0
