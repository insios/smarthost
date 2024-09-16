#!/bin/bash

echo '### '
echo
echo '```ini'
cat /opt/icms2/var.init/config/version.ini
echo
echo '```'
echo

echo -n '### PHP: '
php -r 'echo phpversion() . "\n";'
echo
echo '```text'
php -v
echo '```'
echo
echo '#### PHP modules'
echo
php -m | grep '^[^\[].' | sed ':a;N;$!ba;s/\n/, /g' | fmt -w 80
echo
echo '#### Composer'
echo
composer --version
echo

echo '### Other'
echo
echo -n '* '
nginx -v