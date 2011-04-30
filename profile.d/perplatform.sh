PLATFORM=
if [ `uname` = 'Darwin' ] ; then
	#echo "Darwin"
	#export TERM=linux
	alias pdfmerge="/usr/bin/python '/System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py' -o merged.pdf"
	#PLATFORM=Mac
	#export SSHAGENT=/usr/bin/ssh-agent
	#export SSHAGENTARGS="-s"
	#if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
		#eval `$SSHAGENT $SSHAGENTARGS`
		#trap "kill $SSH_AGENT_PID" 0
	#fi

elif [ `uname` = 'Linux' ] ; then
	if [ -f /etc/fedora-release ] ; then
		PLATFORM=Fedora
	elif [ -f /etc/redhat-release ] ; then
		PLATFORM=Redhat
	else
		PLATFORM=Linux
	fi
fi
export PLATFORM
