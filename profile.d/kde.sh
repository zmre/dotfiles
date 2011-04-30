# KDE initialization script (sh)
if [ -z "$KDEDIR"  -o  "$KDEDIR" != "/usr" ] ; then
	KDEDIR="/usr"
	kdepath="$KDEDIR/bin"
	if ! echo $PATH | grep -q "$kdepath" ; then
        	PATH="$kdepath:$PATH"
        fi
fi
export  KDEDIR PATH
