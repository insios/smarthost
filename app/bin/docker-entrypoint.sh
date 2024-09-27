#!/bin/sh

# Running syslogd
syslogd -n -O - &

run_d () {
    d_root="$1"
    logger "Running entrypoint scripts from $d_root"
    if /usr/bin/find "$d_root" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        logger "Looking for shell scripts..."
        find "$d_root" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.sh)
                    if [ -x "$f" ]; then
                        logger "Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        logger "Ignoring $f, not executable";
                    fi
                    ;;
                *) logger "Ignoring $f";;
            esac
        done
    else
        : # logger "No files found"
    fi
}

run_d $APP_LIB/etc/docker-entrypoint.d
run_d $APP_CONF/docker-entrypoint.d

# Running syslogd
# syslogd -n -O - &

# logger "Running saslauthd"
# saslauthd -c -a sasldb

logger "Running opendkim"
opendkim -A

$APP_LIB/bin/conf-host-ip.sh

logger "Running postfix"
case "$1" in
    "postfix" | "")
        exec postfix start-fg
        ;;
    "test")
        postfix start
        exec $APP_LIB/bin/test.sh $@
        ;;
    *)
        postfix start
        exec $@
        ;;
esac
