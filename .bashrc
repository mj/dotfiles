UNAME=$(uname)

export VISUAL=joe

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
alias la='ls -A'
alias lal='ls -la'
alias l='ls -CF'
alias genpasswd='dd if=/dev/random ibs=6 count=1 2>/dev/null | openssl base64'

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
    test -x /opt/local && {
        PORTS=/opt/local

        # setup the PATH and MANPATH
        PATH="$PORTS/bin:$PORTS/sbin:$PATH"
        MANPATH="$PORTS/share/man:$MANPATH"
    }  
fi

if [ "$PS1" ]; then

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
fi

#
# Daily history files
#
# http://bradchoate.com/weblog/2006/05/19/daily-history-files-for-bash
#
export HISTFILE=$HOME/.history/`date +%Y%m%d`.hist
export HISTSIZE=100000

uname -npsr
uptime
