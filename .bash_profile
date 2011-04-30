# .bash_profile
if [ -f /etc/profile ] ; then
	. /etc/profile
fi

# Get the aliases and functions
if [ -f $HOME/.bashrc ]; then
        . $HOME/.bashrc
fi


# User specific environment and startup programs

PATH=$PATH:$HOME/bin
ENV=$HOME/.bashrc

HISTIGNORE="&:ls:[bf]g:exit"
export USERNAME ENV PATH HISTIGNORE

shopt >& /dev/null
if [ $? -eq 0 ] ; then
	shopt -s cdspell
	shopt -s cmdhist
	shopt -s checkwinsize
fi

if [ -e ~/.login ] ; then
	source ~/.login
fi
if [ -e ~/profile.d/path.sh ] ; then
	source ~/profile.d/path.sh
fi

export MANPATH=/opt/local/share/man:$MANPATH

