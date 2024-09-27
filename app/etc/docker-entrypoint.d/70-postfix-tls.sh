#!/bin/sh

tls_level=$(postconf -h smtpd_tls_security_level)
if [ ! -z "$tls_level" ]; then
    tls_crt=$(postconf -h smtpd_tls_cert_file)
    if [ ! -f "$tls_crt" ]; then
        logger "TLS enabled but certificate file $tls_crt not found"
        tls_dir="$APP_VAR/postfix"
        tls_crt="$tls_dir/tls.crt"
        tls_key="$tls_dir/tls.key"
        myhostname=`postconf -h myhostname`
        logger "Generating new self signed certificate $tls_crt for domain $myhostname"
        [[ -d $tls_dir ]] || mkdir -p $tls_dir
        openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
            -nodes -keyout $tls_key -out $tls_crt -subj "/CN=$myhostname" \
            -addext "subjectAltName=DNS:localhost,DNS:localhost.localdomain,IP:127.0.0.1"
        postconf -e smtpd_tls_cert_file="$tls_crt"
        postconf -e smtpd_tls_key_file="$tls_key"
    fi
fi
