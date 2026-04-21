#!/usr/bin/python3
import subprocess
import re, sys, os
import json
import requests
from urllib.parse import urlparse, urlunparse, quote

AI_HOST = os.environ.get('GITAPPER_AI_HOST', '')
AI_KEY = os.environ.get('GITAPPER_AI_KEY', '')
AI_MODEL = os.environ.get('GITAPPER_AI_MODEL', 'gpt-3.5-turbo')


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
        print(f"Error: {e}")
        return ""

    return None


def get_ai_commit_message(diff_content):
    if not AI_HOST or not AI_KEY:
        return None

    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {AI_KEY}'
    }

    prompt = f"""Analyze the following git diff and generate a conventional commit message.
The format should be: <type>(<scope>): <description>

Types: fix, feat, docs, style, refactor, perf, test, build, ci, chore, revert
Rules:
- Use imperative mood ("add" not "added")
- Keep subject line under 72 characters
- No period at end

Git diff to analyze:
{diff_content[:10000]}

Respond ONLY with the commit message."""

    payload = {
        'model': AI_MODEL,
        'messages': [
            {'role': 'system', 'content': 'You generate conventional commit messages.'},
            {'role': 'user', 'content': prompt}
        ],
        'max_tokens': 100,
        'temperature': 0.3
    }

    try:
        response = requests.post(
            f'{AI_HOST}/chat/completions',
            headers=headers,
            json=payload,
            timeout=30
        )
        if response.status_code == 200:
            result = response.json()
            return result['choices'][0]['message']['content'].strip()
    except Exception as e:
        print(f"AI commit generation failed: {e}")

    return None


def get_staged_diff():
    try:
        result = subprocess.run(
            ['git', 'diff', '--staged', '--no-color'],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError:
        return ''


def main():
    pattern = r'(fix|feat|docs|style|refactor|perf|test|build|ci|chore|revert)(\([\w\-]+\))?:\s.*'
    commit = sys.argv[2]
    commit = commit[7:]

    # If no -m flag, generate commit message with AI
    if commit[0:2] != '-m':
        diff = get_staged_diff()
        if diff:
            ai_message = get_ai_commit_message(diff)
            if ai_message:
                commit = ai_message
            else:
                print("No staged changes or AI not configured. Run 'git commit -m \"type: description\"'")
                sys.exit(1)
        else:
            print("No staged changes. Run 'git add' first.")
            sys.exit(1)
    else:
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