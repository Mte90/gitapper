#!/usr/bin/env python
import re, sys, os
import dbus

# Validate commits like https://www.conventionalcommits.org/en/v1.0.0/

def get_vlc_track_info():
    session_bus = dbus.SessionBus()

    vlc_media_player = session_bus.get_object('org.mpris.MediaPlayer2.vlc', '/org/mpris/MediaPlayer2')
    vlc_interface = dbus.Interface(vlc_media_player, 'org.freedesktop.DBus.Properties')

    metadata = vlc_interface.Get('org.mpris.MediaPlayer2.Player', 'Metadata')

    if 'xesam:audio' in metadata and metadata['xesam:audio']:
        title = metadata.get('xesam:title', 'No Title')
        artist = metadata.get('xesam:artist', ['No author'])[0]
        return title, artist
    else:
        return None, None

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
        title, artist = get_vlc_track_info()
        if title != None:
            commit += f"\n √ ♬ {artist} - {title}"
        os.system(sys.argv[1] + ' commit -m "' + commit + '"')
        sys.exit(1)


if __name__ == "__main__":
    main()
