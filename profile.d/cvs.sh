export CVS_RSH=/usr/bin/ssh
#export CVSEDITOR=vim
#export SVN_EDITOR=vim
export CVSROOT="192.168.100.4:/home/cvsroot"
alias cup="if [ -d CVS ] ; then cvs -q update -d ; else svn update ; fi"
alias cin="if [ -d CVS ] ; then cvs -Q diff -u |less -F; echo Press return to continue or ctrl-c to abort... && read && cvs -q ci ; else svn diff |less -F; echo Press return to continue or ctrl-c to abort... && read && svn ci; fi"
