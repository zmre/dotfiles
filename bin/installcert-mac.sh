#!/bin/sh
VER="1.0"

HOST=""
FILE=""
echo "installcert, version $VER"

if [ "$#" == "0" ] ; then
	echo "usage: `basename $0` -h for help"
	exit 2
fi

while getopts ":hH:F:" Option
do 
	case $Option in
		H ) HOST=$OPTARG
			FILE="/tmp/cert.pem";
			echo "" | openssl s_client -showcerts -connect $HOST 2>&1 | sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' > $FILE ;;

		F ) FILE=$OPTARG ;;
		h | * ) 
			echo ""
			echo "usage: `basename $0` [-H hostname:port | -F certfile]" 
			echo "" 
			echo "  H : host name and port"
			echo "  F : filename to server .cer certificate"
			echo "  h : this help screen" 
			echo ""
			exit 0;;
	esac
done
shift $(($OPTIND - 1))

# Check the file type.  If it is a .pem file, do this:
openSSL x509 -in $FILE -inform pem -out /tmp/cert.der -outform der
FILE=/tmp/cert.der

if [ "`whoami`" != "root" ] ; then
	echo "You will need to enter your password to continue."
fi

sudo cp /System/Library/Keychains/X509Anchors ~/Library/Keychains/X509Anchors
cd ~/Library/Keychains
certtool i $FILE k=X509Anchors d
sudo cp ~/Library/Keychains/X509Anchors /System/Library/Keychains

