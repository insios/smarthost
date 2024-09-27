#!/bin/sh

if [ -d "$APP_CONF/opendkim" ]; then
   ln -sf $APP_CONF/opendkim /etc/opendkim/smarthost
else
   mkdir -p $APP_VAR/opendkim
   touch $APP_VAR/opendkim/keytable
   touch $APP_VAR/opendkim/signingtable
   ln -sf $APP_VAR/opendkim /etc/opendkim/smarthost
fi
