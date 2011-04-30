# color-ls initialization
if [ -x '/usr/bin/dircolors' ] ; then
	DIRCOLORS=/usr/bin/dircolors
elif [ -x '/sw/bin/dircolors' ] ; then
	DIRCOLORS=/sw/bin/dircolors
elif [ -x '/opt/local/bin/gdircolors' ] ; then
	DIRCOLORS=/opt/local/bin/gdircolors
else
	DIRCOLORS=dircolors
fi

eval `$DIRCOLORS --sh $HOME/profile.d/DIR_COLORS`
if echo $SHELL |egrep 'bin/b?a?sh' 2>&1 >/dev/null; then # aliases are bash only
	if [ `uname` = 'Darwin' ] ; then
		alias ll='ls -F -l -G -F'
		alias l.='ls .[a-zA-Z]* -F -F -G'
		alias ls='ls -F -F -G'
	else
		alias ll='ls -F -l --color=tty'
		alias l.='ls .[a-zA-Z]* -F --color=tty'
		alias ls='ls -F --color=tty'
	fi
fi
