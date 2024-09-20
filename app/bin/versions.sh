#!/bin/bash

os_name=$(grep '^NAME=' /etc/os-release | awk -F '"' '{print $2}')
os_ver=$(grep '^VERSION_ID=' /etc/os-release | awk -F '=' '{print $2}')
postfix_ver=$(postconf -d mail_version | awk -F ' = ' '{print $2}')
openssl_ver=$(openssl --version | awk -F ' ' '{print $2}')
libsasl_ver=$(saslpasswd2 -v 2>&1 | grep 'LibSasl version' | awk -F ' ' '{print $3}')
opendkim_ver=$(opendkim -V | grep 'opendkim:' | awk -F ' v' '{print $2}')

# echo "OS: $os_name $os_ver"
# echo "Postfix: $postfix_ver"
# echo "OpenDKIM: $opendkim_ver"
# echo "OpenSSL: $openssl_ver"
# echo "LibSasl: $libsasl_ver"

echo "Versions: $os_name $os_ver, Postfix $postfix_ver, OpenDKIM $opendkim_ver, OpenSSL $openssl_ver, LibSasl $libsasl_ver"
