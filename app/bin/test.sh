#!/bin/bash

logger 'Running test'
if [ -f "$APP_CONF/tests/$2.txt" ]; then
    cat "$APP_CONF/tests/$2.txt" | msmtp -v --read-envelope-from --read-recipients
    cmd="$3"
else
    echo "$3" | msmtp -v $2
    cmd="$4"
fi
sleep 3
if [ ! -z "$cmd" ]; then
    exec $cmd
fi
