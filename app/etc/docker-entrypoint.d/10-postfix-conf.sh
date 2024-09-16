#!/bin/sh

apply_f () {
    case "$1" in
        *conf)
            logger "Applying postfix config from file $1"
            while IFS="" read -r c || [ -n "$c" ]
            do
                if [ ! -z "$c" ] && [[ "$c" != \#* ]]; then
                    eval "postconf $c"
                fi
            done < $1
            ;;
        *sh)
            logger "Executing postfix config file $1"
            $1
            ;;
        *)
            logger "Ignoring $1"
            ;;
    esac
}

apply_d () {
    logger "Applying postfix config from directory $1"
    find "$1" -follow -type f -print | sort -V | while read -r f; do
        apply_f "$f"
    done
}

[ -d "$APP_LIB/etc/postfix.d" ] && apply_d "$APP_LIB/etc/postfix.d"
[ -d "$APP_CONF/postfix.d" ] && apply_d "$APP_CONF/postfix.d"
