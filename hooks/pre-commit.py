#!/usr/bin/python3
import subprocess
import re, sys, os
import requests
from urllib.parse import urlparse, urlunparse, quote

# Validate commits like https://www.conventionalcommits.org/en/v1.0.0/

def check_url_status(url):
    parsed_url = urlparse(url)
    url = urlunparse(
        (parsed_url.scheme, parsed_url.netloc, quote(parsed_url.path),
         parsed_url.params, parsed_url.query, parsed_url.fragment)
    )
    try:
        response = requests.get(url)

        if response.status_code == 404 or response.status_code == 403:
            return False
        else:
            return True
    except requests.exceptions.RequestException as e:
        return False

def get_vlc_track_info():
    result = subprocess.run("git remote get-url origin", shell=True, text=True, capture_output=True)
    url = result.stdout.replace(".git","").replace(":","/").replace("git@", "https://").replace('%0A',"")

    if check_url_status(url) is False:
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
        if artist == "Unknown Artist":
            return ""

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
