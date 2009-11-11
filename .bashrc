PATH=~/bin:/usr/local/bin:"${PATH}"
export VISUAL=joe

mkcd() {
	mkdir -p "$1"
	cd "$1"
}

svnrm () {
        svn remove $@
        svn commit $@
}

svnadd () {
        svn add $* && svn commit $*
}

# If running interactively, then:
if [ "$PS1" ]; then
    # enable color support of ls and also add handy aliases
    if [ "$TERM" != "dumb" ]; then
        eval `dircolors -b`
        alias ls='ls --color=auto'
        alias dir='ls --color --format=vertical'
        alias vdir='ls --color --format=long'
    fi

    alias ll='ls -l'
    alias la='ls -A'
    alias lal='ls -la'
    alias l='ls -CF'
    alias m=mutt
    alias genpasswd='dd if=/dev/random ibs=6 count=1 2>/dev/null | openssl base64'
    alias conflicts="find . -type f \! -name '*.o' -print0 | xargs -0 grep -l '<<<<<<'"

    # Aliases for Subversion
    alias sgrep='rgrep --exclude "*.svn*"'
    alias slock='svn lock -m ""'
    alias smod='svn status | grep ^M'
    alias svn-affected-files='svn log --verbose -r'
    alias screen='TERM=screen screen'

    # set a fancy prompt
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

    # If this is an xterm set the title to user@host:dir
    case $TERM in
    xterm*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *)
        ;;
    esac

    # Initialize Keychain
    keychain -q id_rsa id_dsa
    source ~/.keychain/${HOSTNAME}-sh

    source /etc/bash_completion
fi
