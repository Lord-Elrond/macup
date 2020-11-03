#!/bin/bash

CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install python3

defaults write com.apple.Finder AppleShowAllFiles true
chsh -s /bin/bash

python3 "$CURDIR"/macup.py --build
