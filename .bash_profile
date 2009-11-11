export LC_CTYPE=de_DE

#
# Daily history files
#
# http://bradchoate.com/weblog/2006/05/19/daily-history-files-for-bash
#
export HISTFILE=$HOME/.history/`date +%Y%m%d`.hist
export HISTSIZE=100000

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

               