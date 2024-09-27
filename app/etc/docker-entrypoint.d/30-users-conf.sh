#!/bin/bash

# sasl_dom=$(postconf -h smtpd_sasl_local_domain)
sasl_dom=""

apply_f () {
    [[ -z "$sasl_dom" ]] && sasl_dom=$(postconf -h smtpd_sasl_local_domain)
    case "$1" in
        *conf)
            logger "Adding users from file $1"
            while IFS="" read -r c || [ -n "$c" ]
            do
                if [ ! -z "$c" ] && [[ "$c" != \#* ]]; then
                    read -a ca <<< "$c"
                    # logger "Adding user ${ca[0]}@$sasl_dom"
                    echo "${ca[1]}" | saslpasswd2 -p -c -u $sasl_dom "${ca[0]}"
                fi
            done < $1
            ;;
        *sh)
            logger "Executing users config file $1"
            $1
            ;;
        *)
            logger "Ignoring $1"
            ;;
    esac
}

apply_d () {
    logger "Adding users from directory $1"
    find "$1" -follow -type f -print | sort -V | while read -r f; do
        apply_f "$f"
    done
}

[ -d "$APP_LIB/etc/users.d" ] && apply_d "$APP_LIB/etc/users.d"
[ -d "$APP_CONF/users.d" ] && apply_d "$APP_CONF/users.d"
