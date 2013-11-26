dotfiles
========

bash shell dotfiles on master branch
--------

**prompt.sh** will show up your virtualenv (if activated), your git branch (when on a git repo) color-coded as green for no changes and red for changes.

*note* I use to create virtualenvs inside my main project folder

e.g.

    my_django_project/

    -----------------/my_django_app

    -----------------/manage.py

    -----------------/venv

and I also wanted to see the project name (which is the same as my project's folder), so instead of showing up the venv name when virtualenv is activated I show up the upper folder.

If you don't like this behaviour, just comment out the line

    PS1="$cyan(`basename \`dirname \"$VIRTUAL_ENV\"\``)$reset $PS1"

and uncomment the line

    #PS1="(`basename \"$VIRTUAL_ENV\"`)$PS1"

inside the prompt.sh

**.bash_aliases** substitute apt-get with aptitude and add some shortcuts for changing folders faster



powershell dotfiles on windows branch
--------

**Microsoft.PowerShell_profile.ps1** set some aliases and start the `pshazz` addon from the [scoop command line installer](http://scoop.sh/)

--------
Feel free to fork and contribute.
