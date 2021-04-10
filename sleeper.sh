#!/bin/bash
DUE=$1
DUR=$(($1 + $2))
while [ `echo "SELECT strftime('%s','now');" | sqlite3` -lt $DUE ] ;do
        sleep 5
done
recAudio &
PID=$!
until [ `echo "SELECT strftime('%s','now');" | sqlite3` -gt $DUR ] ; do
        sleep 5
done
kill -2 $PID
ncftpput 192.168.0.2 /incoming *aiff

