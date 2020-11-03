#!/usr/bin/env python3
import argparse
import json

from pathlib import Path
from itertools import chain


BASE_DIR = Path(__file__).resolve().parent

def backup():
    print("Error: TODO")
    return exit(1)

def _find_virtualenvwrapper():
    paths = (
        Path('~/Library/Python/').expanduser().glob('**/bin/virtualenvwrapper.sh'),
        Path('/usr/local').glob('**/bin/virtualenvwrapper.sh'),
    )
    for path in chain(*paths):
        if path.is_file():
            return str(path)

    print("Couldn't find the path to `virtualenvwrapper.sh` again... skipping...")

def _build_bash_profile():
    with open(BASE_DIR/'profile.sh') as fp:
        bash_profile = fp.read()
        if virtualenv_path := _find_virtualenvwrapper():
            bash_profile = bash_profile.replace('# VIRTUALENVPATH', f'source {virtualenv_path}')

    bp_path = Path('~/.bash_profile').expanduser()
    with open(bp_path, 'w+') as fp:
        fp.write(bash_profile)

def _brew_install(brew_taps, brew_casks):
    cask_cmd = 'brew cask install ' + ' '.join(brew_casks)
    os.system(cask_cmd)

    tap_cmd = 'brew install ' + ' '.join(brew_taps)
    os.system(tap_cmd)

def build():
    with open(BASE_DIR/'config.json') as fp:
        config = json.load(fp)
        _brew_install(config['taps'], config['casks'])
    _build_bash_profile()



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-b', '--build', action='store_true')
    args = parser.parse_args()

    if args.build:
        build()
    else:
        backup()

if __name__ == '__main__':
    main()
