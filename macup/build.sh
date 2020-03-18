#!/bin/bash

CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MACUP_DIR="$HOME/.macup"

function python_required() {
  echo -e "This package requires python 3\n"
  read -n 1 -p "Do you want to install it automatically? (y/n)" response

  if [ "$response" = "y" ]; then
    brew install python3
  else
    exit 1
  fi
}

function build_from_url() {
  if [ -z "$1" ]; then
    echo "build.sh requires a github url"
    exit 1
  fi

  git_url="$1"
  git clone "$git_url" "$MACUP_DIR" 2>/dev/null

  if [ ! $? -eq 0 ]; then
    echo "error at git clone"
    exit 1
  fi

  if [ ! -f "$MACUP_DIR"/config.json ]; then
    mkdir -p "$MACUP_DIR/domains"
    cp "$CURDIR/config.json" "$MACUP_DIR/config.json"
  fi
}

command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
command -v python3 >/dev/null 2>&1 || python_required

cp "$CURDIR"/macup.py /usr/local/bin/macup
build_from_url "$1"
