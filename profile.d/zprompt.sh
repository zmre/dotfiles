  NONE="\[\033[0m\]"    # unsets color to term's fg color

  # regular colors
  K="\[\033[0;30m\]"    # black
  R="\[\033[0;31m\]"    # red
  G="\[\033[0;32m\]"    # green
  Y="\[\033[0;33m\]"    # yellow
  B="\[\033[0;34m\]"    # blue
  M="\[\033[0;35m\]"    # magenta
  C="\[\033[0;36m\]"    # cyan
  W="\[\033[0;37m\]"    # white
  # emphasized (bolded) colors
  EMK="\[\033[1;30m\]"
  EMR="\[\033[1;31m\]"
  EMG="\[\033[1;32m\]"
  EMY="\[\033[1;33m\]"
  EMB="\[\033[1;34m\]"
  EMM="\[\033[1;35m\]"
  EMC="\[\033[1;36m\]"
  EMW="\[\033[1;37m\]"
  # background colors
  BGK="\[\033[40m\]"
  BGR="\[\033[41m\]"
  BGG="\[\033[42m\]"
  BGY="\[\033[43m\]"
  BGB="\[\033[44m\]"
  BGM="\[\033[45m\]"
  BGC="\[\033[46m\]"
  BGW="\[\033[47m\]"


#    if [ "x`tput kbs`" != "x" ]; then # We can't do this with "dumb" terminal
#        stty erase `tput kbs`
#    fi
    case $TERM in
	xterm*)
	    export TITLEBAR="\[\033]0;\u@\h:\w\007\]"
	    ;;
	linux*)
	    export TITLEBAR="\[\033]0;\u@\h:\w\007\]"
	    ;;
	*)
	    export TITLEBAR=""
	    ;;
    esac

if [ -z $WHOAMI ] ; then
	WHOAMI=`whoami`
fi
if [ -n "$REALHOST" ] ; then
	export HOST=$REALHOST
fi
if [ -z $HOST ] ; then
	export HOST=`grep 127 /etc/hosts |awk -F '[ \t]' '{print $3}' |grep -v '^$'`
	if [ "$HOST" = "" -o "$HOST" = "localhost" -o "$HOST" = "localhost.localdomain" ] ; then
		HOST=`scutil --get LocalHostName 2>&1`
		if [ $? -ne 0 ] ; then
			HOST=`hostname -s 2>&1`
			if [ $? -ne 0 ] ; then
				HOST=`hostname`
			fi
		fi
		export HOST
	fi
fi

#PS1="\u@\h:\w\\$ "
#PROMPT_COMMAND='source ~/profile.d/prompt'

# Colorless prompt:
#export PS1="[\u@\h:\w (\$?)]\n\$ "

function __git_dirty {
  return
  git diff --quiet HEAD &>/dev/null
  [ $? == 1 ] && echo "!"
}

function __git_branch {
  __git_ps1 "[%s]"
}

if [ "$WHOAMI" == 'root' ] ; then
	PROMPTCHAR=#
else
	PROMPTCHAR=\$
fi

# Color prompt:
export PS1="${TITLEBAR}$NONE[$C\u$NONE@$C\h$NONE:$G\w$NONE $R\$(__git_dirty)\$(__git_branch)$NONE($B\$?$NONE)] $Y\$(jobs)\n$NONE$PROMPTCHAR "
