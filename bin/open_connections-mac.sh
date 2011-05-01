#!/bin/sh

echo Reminder: lsof -P -n -i
lsof -P -n -i |grep -v 127.0.0.1
# netstat -a -n |grep LISTEN
