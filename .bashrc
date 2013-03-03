# ~martin/.bashrc
#
# Heavily inspired by Debian's default .bashrc, http://github.com/rtomayko/dotfiles,
# http://hocuspokus.net/2008/01/a-better-ls-for-mac-os-x and assorted other
# .bashrc files over the web.
#

# I don't care about non-interactive shells
[ -z "$PS1" ] && return

UNAME=$(uname)

export VISUAL=joe
export LANG=en_US.UTF-8

mkcd() {
    test -z "$1" && return

    mkdir -p "$1"
    cd "$1"
}

# handy aliases for SVN
alias sgrep='rgrep --exclude "*.svn*"'
alias slock='svn lock -m ""'
alias smod='svn status | grep ^M'
alias svn-affected-files='svn log --verbose -r'

svnrm () {
    svn remove $@
    svn commit $@
}

svnadd () {
    svn add $* && svn commit $*
}

alias screen='TERM=screen screen'
alias conflicts="find . -type f \! -name '*.o' -print0 | xargs -0 grep -l '<<<<<<'"
alias ll='ls -l'
alias la='ls -lA'
alias lal='ls -la'
alias l='ls -CF'
alias lsd='ll | grep ^d'
alias genpasswd='dd if=/dev/random ibs=6 count=1 2>/dev/null | openssl base64'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"

# Enable aliases to be sudo’ed
alias sudo='sudo '

HAVE_RGREP=$(command -v rgrep)
if [ -z "$HAVE_RGREP" ]; then
    alias rgrep="grep -r"
fi

# Put various paths on the environment
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

if [ "$UNAME" = Darwin ]; then
    # put MacPorts on the environment
    PORTS="/opt/local"
    if [ -x $PORTS ]; then
        # setup the PATH and MANPATH
        PATH="$PORTS/bin:$PORTS/sbin:$PATH"
        MANPATH="$PORTS/share/man:$MANPATH"
    fi
else
    alias ls="ls --color"
fi

# detect login shell
case "$0" in
    -*) LOGIN=1 ;;
    *) unset LOGIN ;;
esac


if [ -n "$(command -v dircolors)" ]; then
    eval `dircolors -b`
fi

# set a fancy prompt
PS1='\u@\h:\w\$ '

# If this is an xterm set the title to user@host:dir
case $TERM in
xterm*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac

# Initialize Keychain
if [ -f "~/.keychain/${HOSTNAME}-sh" ]; then
    keychain -q id_rsa id_dsa
    source ~/.keychain/${HOSTNAME}-sh
fi

test -f "/etc/bash_completion" && source /etc/bash_completion

#
# Settings regarding the history file
#

# Don't put duplicate lines in the history file
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Make sure the same location for the history file is used all the time.
export HISTFILE=$HOME/.bash_history

# Set some sane limits for the history size
export HISTSIZE=100000
export HISTFILESIZE=100000

# append to the history file, don't overwrite it
shopt -s histappend

#
# MOTD-type settings
#

test -n "$LOGIN" && {
    # show some useful information on login
    uname -npsr
    uptime
}
