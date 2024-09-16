#!/bin/sh

if [ ! -z "$SH_VERBOSE" ]; then
    postconf -M -e submission/inet="submission inet n - n - - smtpd -v"
fi

if [ ! -z "$SH_HOSTNAME" ]; then
    postconf -e myhostname="$SH_HOSTNAME"
    postconf -e smtp_helo_name="$SH_HOSTNAME"
fi

if [ ! -z "$SH_RELAY_HOST" ]; then
    postconf -e relayhost="$SH_RELAY_HOST"
fi
if [ ! -z "$SH_RELAY_USERNAME" ]; then
    postconf -e smtp_sasl_auth_enable="yes"
    postconf -e smtp_sasl_security_options="noanonymous"
    postconf -e smtp_sasl_password_maps="static:$SH_RELAY_USERNAME:$SH_RELAY_PASSWORD"
fi
if [ ! -z "$SH_RELAY_TLS" ]; then
    postconf -e smtp_tls_security_level="encrypt"
fi

if [ ! -z "$SH_ALLOWED_NETWORKS" ]; then
    postconf -e mynetworks="$SH_ALLOWED_NETWORKS"
fi

if [ ! -z "$SH_AUTH" ]; then
    postconf -e smtpd_sasl_auth_enable="yes"
    postconf -e smtpd_client_restrictions="permit_sasl_authenticated, reject"
    sasl_dom=$(postconf -h smtpd_sasl_local_domain)
    username=$(echo "$SH_AUTH" | cut -d ":" -f 1)
    password=$(echo "$SH_AUTH" | cut -d ":" -f 2)
    echo "$password" | saslpasswd2 -p -c -u "$sasl_dom" "$username"
fi

if [ ! -z "$SH_TLS_LEVEL" ]; then
    postconf -e smtpd_tls_security_level="$SH_TLS_LEVEL"
fi
if [ ! -z "$SH_TLS_CRT" ]; then
    postconf -e smtpd_tls_cert_file="$APP_CONF/$SH_TLS_CRT"
fi
if [ ! -z "$SH_TLS_KEY" ]; then
    postconf -e smtpd_tls_key_file="$APP_CONF/$SH_TLS_KEY"
fi
