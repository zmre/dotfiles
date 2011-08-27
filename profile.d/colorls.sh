# color-ls initialization

# The color designators are as follows:
#
# a black
# b red
# c green
# d brown
# e blue
# f magenta
# g cyan
# h light grey
# A bold black, usually shows up as dark grey
# B bold red
# C bold green
# D bold brown, usually shows up as yellow
# E bold blue
# F bold magenta
# G bold cyan
# H bold light grey; looks like bright white
# x default foreground or background
#
# Note that the above are standard ANSI colors. The actual
# display may differ depending on the color capabilities of
# the terminal in use.
#
# The order of the attributes are as follows:
#
# 1. directory
# 2. symbolic link
# 3. socket
# 4. pipe
# 5. executable
# 6. block special
# 7. character special
# 8. executable with setuid bit set
# 9. executable with setgid bit set
# 10. directory writable to others, with sticky bit
# 11. directory writable to others, without sticky bit
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

if [ -x '/usr/bin/dircolors' ] ; then
	DIRCOLORS=/usr/bin/dircolors
elif [ -x '/sw/bin/dircolors' ] ; then
	DIRCOLORS=/sw/bin/dircolors
elif [ -x '/opt/local/bin/gdircolors' ] ; then
	DIRCOLORS=/opt/local/bin/gdircolors
else
	DIRCOLORS=false
    export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:"
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
