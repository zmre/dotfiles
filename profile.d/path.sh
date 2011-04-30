PATH=
addpath () {
	for i in $1 ; do
		if [ -d $i -a -x $i ] ; then
			PATH=${PATH}$i:
		fi
	done
}

#addpath "$HOME/scripts"
addpath "$HOME/bin"
addpath "$HOME/Scripts"
addpath "/sw/bin"
addpath "/opt/local/bin"
addpath "/usr/local/bin"
addpath "/opt/local/sbin"
addpath "/usr/local/sbin"
addpath "/usr/local/pgsql/bin"
addpath "/usr/X11R6/bin"
addpath "/usr/lib/qt-*/bin"
addpath "/usr/kerberos/bin"
addpath "/usr/lib/courier-imap/sbin"
addpath "/usr/lib/courier-imap/bin"
addpath "/usr/local/ti/bin"
addpath "/root/bin"
addpath "/usr/java/*/bin"
addpath "/opt/IBMJava2*/jre/bin"
addpath "/usr/local/*/bin"
addpath "/usr/local/*/sbin"
addpath "/opt/local/lib/postgresql82/bin"
addpath "/opt/local/lib/postgresql81/bin"
addpath "/usr/local/mongodb/bin"
addpath "/usr/bin"
addpath "/usr/sbin"
addpath "/bin"
addpath "/sbin"
export PATH
