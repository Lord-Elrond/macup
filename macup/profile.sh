#!/bin/bash

alias staticdir="mkdir static static/js static/css"
alias dj="python manage.py"
alias run="python manage.py runserver"
alias pyt="python3 ~/Code/test/test.py"
alias t="cd ~/Code/test && atom -a ."
alias djs="./manage.py shell_plus"
alias djt="./manage.py test"
alias mkenv="mkvirtualenv"

# export VIRTUALENVWRAPPER_PYTHON=/usr/local/Cellar/python3
export WORKON_HOME=~/Envs
export BASH_SILENCE_DEPRECATION_WARNING=1

mkdir -p $WORKON_HOME

function djmg() {
	python manage.py makemigrations
	if [ $# -eq 0 ]
		then
			python manage.py migrate
	elif [ $# -eq 1 ]
		then
			python manage.py migrate --database="$1"
	else
		for arg in $@; do
			python manage.py migrate --database=$arg
		done
	fi
}

function djclear() {
  dir="${PWD##*/}"
  if [ -d $dir ]; then
	   find . -path "*/migrations/*.py" -not -name "__init__.py" -not -path "./env/*" -delete
	   find . -path "*/migrations/*.pyc" -not -path "./env/*" -delete
  else
    echo "Returning with exit code 1. Are you sure that you are in a project directory?"
    return 1
  fi
}

function djreset() {
  djclear
  python3 ~/Code/shell/shortcuts/djclear.py
  djmg
}

function djapp() {
	python3 manage.py startapp "$1"
	mkdir "$1"/templates
	mkdir "$1"/templates/partials
	mkdir "$1"/static
	mkdir "$1"/static/css
	mkdir "$1"/static/js

}

function djproj() {
	django-admin startproject "$1"
	cd "$1"
	mkdir templates
	mkdir templates/partials
	mkdir static
	mkdir static/css
	mkdir static/js
	mkdir static/images
}

function pcd() {
  cd ~/Code
  workon "$1"
  cd "$1"
  atom -a .
}

function cc() {
	gcc "$1".c "$1"
	"$1"
}

function curdir() {
  CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  echo "$CURDIR"
}

function mcd() {
  mkdir "$1"
  cd "$1"
}

function ocd() {
  cd ~/Code/"$1"
  atom -a .
}
