gnualias() {
	if [ -x /opt/local/bin/g$1 ] ; then
		alias $1="/opt/local/bin/g$1"
	elif [ -x /usr/bin/g$1 ] ; then
		alias $1="/usr/bin/g$1"
	elif [ -x /usr/local/bin/g$1 ] ; then
		alias $1="/usr/local/bin/g$1"
	fi
}

for i in find basename cat chgrp chmod chown chroot cksum comm cp csplit cut date dd df dir dircolors dirname du echo env expand expr factor false fmt fold groups head hostid id install join kill link ln logname ls make md5sum mkdir mkfifo mknod mv nice nl nohup object-query od paste pathchk pinky pr printenv printf ptx pwd readlink rm rmdir seq sha1sum shred sleep sort split stat strings stty su sum sync tac tail tee test touch tr true tsort tty unexpand uniq unlink uptime users vcolor vdir vpack vpr wc who whoami yes ; do
	gnualias $i
done


if [ -f /opt/local/bin/gls ] ; then
	LS=/opt/local/bin/gls
else
	LS=ls
fi

BZIP=`which bzip2`
alias ff="fg %+"
#alias btar="tar --use-compress-program $BZIP "
alias fb="fg %-"
alias fn="fg %?"
alias l.="$LS -F -d .[a-zA-Z]* --color=tty"
alias ll="$LS -F -l --color=tty"
alias ls="$LS -F --color=tty"
alias ..="cd .."
alias ...="cd ../.."
echo x |grep --color y >& /dev/null
if [ $? -ne 2 ] ; then
	alias grep='grep --color'
fi
alias cd=cd
#alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

if [ -d /Users/pwalsh/Dropbox/Dev/NoteViz ] ; then
	alias notev="cd /Users/pwalsh/Dropbox/Dev/NoteViz"
fi

which lft >& /dev/null
if [ $? -eq 0 ] ; then
	alias traceroute='lft -EN '
fi

alias cdf='eval `osascript /Applications/Utilities/OpenTerminal.app/Contents/Resources/Scripts/OpenTerminal.scpt`'
