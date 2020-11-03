#!/bin/bash

alias dj="python manage.py"
alias run="python3 manage.py runserver"
alias pyt="python3 ~/Code/test/test.py"
alias t="cd ~/Code/test && atom -a ."
alias djt="python3 manage.py test"
alias mkenv="mkvirtualenv"
alias rsb="source ~/.bash_profile"

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export WORKON_HOME=~/Envs
export BASH_SILENCE_DEPRECATION_WARNING=1

# VIRTUALENVPATH

djs()
{
  if ! python3 manage.py shell_plus; then
    python3 manage.py shell
  fi
}

gitcd()
{
  if git clone "$1"; then
    dirname="${1##*/}"
    if [[ ! -d ./"$dirname" ]]; then
      # dirname probably has `.git` attached to it
      dirname="${dirname%.*}"
    fi
    cd "$dirname"
  fi
}

rspg()
{
  kill -s TERM $(ps aux | grep '[p]gAdmin4' | awk '{print $2}') && open -a "pgAdmin 4"
}

djmg()
{
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

djclear()
{
  find . -path "*/migrations/*.py" -not -path "*/site-packages/*" -delete
  find . -path "*/migrations/*.pyc" -not -path "*/site-packages/*" -delete

  sqlite_file="${1:-db.sqlite3}"
  if [[ -f "$sqlite_file" ]]; then
    echo >./"$sqlite_file"
  fi
}

pcd()
{
  project_name="$1"
  workon "$project_name" &>/dev/null
  cd ~/Code/"$project_name" && atom "${2:--a}" .
}

curdir()
{
  CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  echo "$CURDIR"
}

mcd()
{
  mkdir "$1" && cd "$1"
}
