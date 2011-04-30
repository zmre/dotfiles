# remove existing aliases first
alias vim >& /dev/null
if [ $? -eq 0 ] ; then
	unalias vim
fi
alias vi >& /dev/null
if [ $? -eq 0 ] ; then
	unalias vi
fi

# look for vim in path
which vim >& /dev/null
if [ $? -eq 0 ] ; then
	alias vi='vim'
	export EDITOR=vim
else
	alias vim='vi'
	export EDITOR=vi
fi
export EXINIT='set autoindent'
if [ -z $VISUAL ] ; then
	export VISUAL=$EDITOR
fi
