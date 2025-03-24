#!/usr/bin/env python3
import subprocess
import re, sys, os

# Validate commits like https://www.conventionalcommits.org/en/v1.0.0/

import subprocess

def get_vlc_track_info():
    bash_command = """
        url=$(git remote get-url origin | sed "s/git@github.com:/https://github.com\//" | sed "s/git@gitlab.com:/https://gitlab.com\//" | sed "s/\.git$//");
        if [ -z "$url" ]; then
            echo "1";
        else
            curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q 404 && echo "1" || echo "0";
        fi
    """
    result = subprocess.run(bash_command, shell=True, text=True, capture_output=True)
    if result != "0":
        return None

    try:
        result = subprocess.run(
            [
                "dbus-send", "--print-reply", "--dest=org.mpris.MediaPlayer2.vlc",
                "/org/mpris/MediaPlayer2", "org.freedesktop.DBus.Properties.Get",
                "string:org.mpris.MediaPlayer2.Player", "string:Metadata"
            ],
            capture_output=True,
            text=True,
            check=True
        )

        lines = result.stdout.split('\n')

        if any("xesam:video" in line for line in lines):
            return ""

        title = "Unknown Title"
        artist = "Unknown Artist"

        it = iter(lines)
        for line in it:
            if "xesam:title" in line:
                try:
                    title = next(it).strip().split('"')[1]
                except StopIteration:
                    pass
            elif "xesam:artist" in line:
                try:
                    next(it)
                    artist_line = next(it).strip()
                    artist = artist_line.split('string "')[-1].split('"')[0]
                except StopIteration:
                    pass

        return f"\n♬ {artist} - {title}"

    except subprocess.CalledProcessError as e:
        return f"Error: {e}"

    return None

def main():
    pattern = r'(fix|feat|docs|style|refactor|perf|test|build|ci|chore|revert)(\([\w\-]+\))?:\s.*'
    commit = sys.argv[2]
    commit = commit[7:]
    if commit[0:2] == '-m':
        commit = commit[3:]
        commit = commit.replace('"', '')
        m = re.match(pattern, commit)
        if m is None:
            print("Conventional commit validation failed")
            print("  Commit types: fix|feat|docs|style|refactor|perf|test|build|ci|chore|revert")
            print("Example: feat(parser): add ability to parse arrays.")
            sys.exit(1)
        song = get_vlc_track_info()
        if song != None:
            commit += song
        os.system(sys.argv[1] + ' commit -m "' + commit + '"')
        sys.exit(1)


if __name__ == "__main__":
    main()
