#!/usr/bin/env python3
import os
import sys
import json
from subprocess import Popen, PIPE

MACUP_DIR = os.path.expanduser('~/.macup')
DOMAINS_DIR = os.path.join(MACUP_DIR, 'domains')
MACUP_CONFIG = os.path.join(MACUP_DIR, 'config.json')

PROFILE_NAME = 'bash_profile'
LOCAL_PROFILE_DIR = os.path.expanduser(os.path.join('~', f'.{PROFILE_NAME}'))
REMOTE_PROFILE_DIR = os.path.join(MACUP_DIR, PROFILE_NAME)

def _write_settings(action, domains):
    for domain in domains:
        if not domain.endswith('.plist'):
            fname = domain + '.plist'
        else:
            fname = domain
        domain_dir = os.path.join(DOMAINS_DIR, fname)
        os.system(f'defaults {action} {domain} {domain_dir}')

def _proc_to_list(proc):
    return proc.stdout.read().decode('utf-8')[:-1].split('\n')

def _get_brew_lists():
    with Popen(['brew', 'leaves'], stdout=PIPE) as leaves_proc, \
        Popen(['brew', 'cask', 'list'], stdout=PIPE) as cask_proc:
        return _proc_to_list(leaves_proc), _proc_to_list(cask_proc)


def _update_local_config():
    with open(MACUP_CONFIG, 'r') as file:
        config = json.load(file)
        _write_settings('export', config['domains'])

    brew_leaves, brew_casks = _get_brew_lists()
    new_config = {
        **config,
        'brew_leaves':brew_leaves,
        'brew_casks':brew_casks
    }

    with open(MACUP_CONFIG, 'w') as file:
        json.dump(new_config, file, indent=4)

def _install_missing_packages(brew_leaves, brew_casks):
    remote_brew_leaves, remote_brew_casks = frozenset(brew_leaves), frozenset(brew_casks)
    local_brew_leaves, local_brew_casks = _get_brew_lists()
    local_brew_leaves = frozenset(local_brew_leaves)
    local_brew_casks = frozenset(local_brew_casks)

    leaves_to_update = ' '.join(remote_brew_leaves - local_brew_leaves)
    casks_to_update = ' '.join(remote_brew_casks - local_brew_casks)

    if leaves_to_update:
        os.system(f'brew install {leaves_to_install}')

    if casks_to_update:
        os.system(f'brew cask install {casks_to_install}')

def _update_local_settings():
    with open(MACUP_CONFIG, 'r') as file:
        config = json.load(file)
        _write_settings('import', config['domains'])
        _install_missing_packages(config['brew_leaves'], config['brew_casks'])

def _git_commands(*commands):
    cmd = ' && '.join(f'git -C {MACUP_DIR} {c}' for c in commands)
    os.system(cmd)

def push_config():
    _update_local_config()
    os.system(f'cp {LOCAL_PROFILE_DIR} {REMOTE_PROFILE_DIR}')
    _git_commands('add -A', 'commit -m "auto"', 'push origin master')

def pull_config():
    _git_commands('fetch --all', 'reset --hard origin/master')
    os.system(f'cp {REMOTE_PROFILE_DIR} {LOCAL_PROFILE_DIR}')
    _update_local_settings()

if __name__ == '__main__':
    arg = sys.argv[1]

    if arg == 'push':
        push_config()
    elif arg == 'pull':
        pull_config()
    else:
        print(f'invalid argument: {arg}')
        sys.exit(1)
