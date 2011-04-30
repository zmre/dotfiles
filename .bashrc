# .bashrc

# User specific aliases and functions

#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'
#alias vim='vi'

# Source global definitions
if [ -f /etc/bashrc ] ; then
	. /etc/bashrc
fi
if [ -f $HOME/profile.d/bashrc ]; then
	. $HOME/profile.d/bashrc
fi

rm -f ~/.varvars
if [ "$DISPLAY" != "" ] ; then
	echo "export DISPLAY=$DISPLAY" >> ~/.varvars
	echo "export SSH_TTY=$SSH_TTY" >> ~/.varvars
	echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> ~/.varvars
fi
