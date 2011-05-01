#!/bin/sh
VER="2.1"

# Copyright 2003 by Patrick J. Walsh.  All rights reserved.
# Released to the public with the condition that proper credit be given
# and enhancements be submitted to pwalsh -at- well.com.


# This script determines your currently running network interfaces,
# whether they're up, what IP they have, name of your computer,
# your location, name of your network port, and possibly more.
#
#   New with v2.0: optionally display wireless network name (SSID)
#   v2.1: fixed network port to be dynamic

NETCAT='nc'
ROUTERPORT=22

while getopts ":hlrdminwSFA" Option
do
	case $Option in
		l ) OPT_LOCATION="1";;
		r ) OPT_TEST_ROUTER="1";;
		d ) OPT_TEST_DNS="1";;
		i ) OPT_INTERFACE_NAME="1";;
		m ) OPT_MACHINE_NAME="1";;
		w ) OPT_SSID_NAME="1";;
		S ) OPT_TEST_DNS="1"; OPT_MACHINE_NAME="1"; OPT_INTERFACE_NAME="1";;
		A ) OPT_TEST_ROUTER="1"; OPT_TEST_DNS="1"; OPT_MACHINE_NAME="1"
			OPT_INTERFACE_NAME="1"; OPT_LOCATION="1"
			OPT_SSID_NAME="1";;
		F ) OPT_MACHINE_NAME="1"; OPT_LOCATION="1" ;;
		h | * ) echo "ipaddresses, version $VER"
			echo ""
			echo "usage: `basename $0` [-hmlinrdSFA]"
			echo ""
			echo "  h : this help screen"
			echo "  m : show machine name"
			echo "  l : show location"
			echo "  i : show interface name (ie en0, en1, etc.)"
			echo "  w : show wireless network SSID name, if applicable"
			echo "  r : check to see if the router is alive"
			echo "  d : check to see if the DNS server is alive"
			echo "  S : Standard display; equivalent to -mid"
			echo "  F : equivalent to -mln"
			echo "  A : Display all; equivalent to -mlinrdw"
			echo ""
			exit 2;;
	esac
done
shift $(($OPTIND - 1))

# Get a list of available interfaces and strip out lo0 -- the loopback connector
INTERFACES=`/sbin/ifconfig -u -l | /usr/bin/sed -n 's/lo0//p'`

# Figure out what location we're in
if [ "$OPT_LOCATION" == "1" ] ; then
	LOCATION="`/usr/sbin/scselect 2>&1 | /usr/bin/sed -n '/^ \* [0-9]*[[:space:]]*(/s//(Location: /p'`"
else
	LOCATION=""
fi

# Get the local hostname and capitalize the first letter
if [ "$OPT_MACHINE_NAME" == "1" ] ; then
	HOST=`/bin/hostname -s`
	H=`echo $HOST | /usr/bin/sed 's/^\(.\)\(.*\)/\1/;y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/'`
	OST="`echo $HOST | /usr/bin/sed 's/^\(.\)\(.*\)/\2/'` "
else
	H=""
	OST=""
fi

# Print host and location, if requested
if [ "$OPT_MACHINE_NAME" == "1" ] ; then
	echo $H$OST$LOCATION
elif [ "$OPT_LOCATION" == "1" ] ; then
	echo $H$OST$LOCATION
fi

# Loop through the interfaces and get the ip address
# If the interface is down, don't print anything
for EN in $INTERFACES
do
	# Get the IP of this interface
	IP="`/sbin/ifconfig $EN inet 2>&1 | grep 'inet ' | /usr/bin/awk '{print $2}'`"

	MSG=""

	# Get the Network Port name, ie "AirPort", "Built-in Ethernet", etc.
	#if [ "$OPT_PORT_NAME" == "1" ] ; then
		#NAME="`egrep -A4 '(DeviceName|UserDefinedName)' /private/var/db/SystemConfiguration/preferences.xml | grep -A2 $EN | grep string | sed "/$EN/d ; s/<[^>]*>//g ; s/[	\t ]*//g" | head -1`"
		#NAME="`grep -A2 $EN /var/db/SystemConfiguration/preferences.xml | grep string | sed "/$EN/d ; s/<[^>]*>//g ; s/[\t ]*//g" |head -1`"
	#fi

	# If the interface is down, the awk line above will return its name
	if [ "$IP" != "$EN" ] ; then
		# Now we know the interface is up.

		# Check the router and dns servers if so instructed by cmd line opts
		if [ "$OPT_TEST_ROUTER" == "1" ] ; then
			if [ "$OPT_TEST_DNS" == "1" ] ; then
				#
				# Both router and DNS tests -- but don't bother with
				# DNS if router is down.
				#
				DNS=`/usr/sbin/ipconfig getoption $EN domain_name_server 2>&1 | grep -v ipconfig`
				ROUTER=`/usr/sbin/ipconfig getoption $EN router 2>&1 | grep -v ipconfig`

				# Check to see that we have a router IP
				if [ "$ROUTER" != "" ] ; then
					# We have a router IP, now try a connection to it
					$NETCAT -n -w 1 -s $IP -z $ROUTER $ROUTERPORT
					if [ $? -eq 0 ] ; then
						# Router is up. Now make sure we have a DNS IP.
						if [ "$DNS" != "" ] ; then
							# We have a DNS IP, now check to see if it is up
							$NETCAT -n -u -w 1 -s $IP -z $DNS 53 || MSG="(DNS down)"
						else
							# No DNS server IP address
							MSG="(No DNS server)"
						fi
					else
						# Router is down -- don't bother checking DNS
						MSG="(Router down)"
					fi
				else
					# No router IP address found
					MSG="(No router)"
				fi
			else
				#
				# Test router and not DNS
				#
				ROUTER=`ipconfig getoption $EN router 2>&1 | grep -v ipconfig`
				if [ "$ROUTER" != "" ] ; then
					# We have a router IP, now try a connection to it
					$NETCAT -n -w 1 -s $IP -z $ROUTER $ROUTERPORT || MSG="(Router down)"
				else
					# No router
					MSG="(No router)"
				fi
			fi
		elif [ "$OPT_TEST_DNS" == "1" ] ; then
			#
			# Test DNS and not router
			#
			DNS=`/usr/sbin/ipconfig getoption $EN domain_name_server 2>&1 | grep -v ipconfig`
			if [ "$DNS" != "" ] ; then
				# We have a DNS IP, now check to see if it is up
				$NETCAT -n -u -w 1 -s $IP -z $DNS 53 || MSG="(DNS down)"
			else
				# No DNS server IP address
				MSG="(No DNS server)"
			fi
		fi

		LABEL=""
		if [ "$OPT_INTERFACE_NAME" == "1" ] ; then
			if [ "$OPT_PORT_NAME" == "1" ] && [ -n "$NAME" ] ; then
				LABEL="${NAME}[$EN]: "
			else
				LABEL="$EN: "
			fi
		elif [ "$OPT_PORT_NAME" == "1" ] ; then
			if [ -n "$NAME" ] ; then
				LABEL="$NAME: "
			else
				LABEL="$EN: "
			fi
		fi

		# If this is interface en1, assume AirPort and get SSID
		if [ "$OPT_SSID_NAME" == "1" ] ; then
			if [ "$EN" == "en1" ] ; then
				SSID="`/usr/sbin/ioreg -c AirPortDriver | sed -n '/^.*"APCurrentSSID" = /s///p'`"
				#MSG="Network: $SSID $MSG"
				MSG="$SSID $MSG"
			fi
		fi

		echo "$LABEL$IP $MSG"
	fi
done;
