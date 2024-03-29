#!/usr/bin/env python
import re, sys, os

# Validate commits like https://www.conventionalcommits.org/en/v1.0.0/


def main():
    pattern = r'(build|ci|docs|feat|fix|perf|refactor|style|test|revert)(\([\w\-]+\))?:\s.*'
    commit = sys.argv[2]
    commit = commit[7:]
    if commit[0:2] == '-m':
        commit = commit[3:]
        commit = commit.replace('"', '')
        m = re.match(pattern, commit)
        if m is None:
            print("Conventional commit validation failed")
            print("  Commit types: build|ci|docs|feat|fix|perf|refactor|style|test|revert")
            print("Example: feat(parser): add ability to parse arrays.")
            sys.exit(1)
        os.system(sys.argv[1] + ' commit -m "' + commit + '"')
        sys.exit(1)


if __name__ == "__main__":
    main()
