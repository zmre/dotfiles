#!/bin/sh

if [ `whoami` != "root" ] ; then
    echo Must be root to backup
    exit 2
fi

LOG=/var/log/backup-rsync-progress.log
STATUS=/var/log/backup-rsync-status.log
HOST=`hostname -s`
DESTINATION=drobo-fs.local

for i in $*
    #/Users/pwalsh/.[a-z]* \
    #/Users/pwalsh/Scripts/ \
    #/Users/pwalsh/bin/ \
    #/Users/pwalsh/Sites/ \
    #/Users/pwalsh/Documents/ \
    #/Users/pwalsh/Applications/ \
    #/Users/pwalsh/Dev/ \
    #/Users/pwalsh/profile.d/ \
    #/Users/pwalsh/Pictures/ \
    #/Applications/ \
    #/Library/ \
    #/Users/pwalsh/Library/ \
    #/Users/pwalsh/Dropbox/
do
    rsync $DESTINATION::
    if [ "$?" != 0 ] ; then
        date | tee $STATUS
        echo "Can't connect to drobo to backup." | tee -a $STATUS
        echo "" > $LOG
        exit 2
    fi
    date | tee $LOG | tee $STATUS
    echo Backing up $i | tee -a $LOG | tee -a $STATUS
    rsync -Cavz --stats -h -P \
	    --exclude='*/.Trashes/*' \
        --exclude='*/Caches/*' \
        --exclude='*/Cache/*' \
        --exclude='*~' \
        --exclude='*.tmp' \
        --exclude='*.bak' \
        --exclude='*/Temporary Items/*' \
        --exclude='*.log' \
        --exclude='*.cache' \
        --exclude=.Trash \
        --exclude=.dropbox \
        --exclude=Cache \
        --exclude=Temp \
        --exclude=tmp \
        --delete \
        "$i" "$DESTINATION::drobofs/$HOST$i" | tee -a $LOG
    date | tee -a $LOG | tee -a $STATUS
    echo Done backing up $i | tee -a $LOG | tee -a $STATUS
done
