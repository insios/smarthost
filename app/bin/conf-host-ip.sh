#!/bin/sh

host_name=$(postconf -h myhostname)
host_ip=$(nslookup $host_name | grep 'Address: ' | awk -F ': ' '{print $2}')
helo_name=$(postconf -h smtp_helo_name)
if [[ "$helo_name" == "$host_name" ]]; then
    helo_ip="$host_ip"
else
    helo_ip=$(nslookup $helo_name | grep 'Address: ' | awk -F ': ' '{print $2}')
fi
public_ip=$(wget -qO- api.ipify.org)
public_rnds=$(nslookup $public_ip | grep 'in-addr.arpa' | awk -F ' = ' '{print $2}')

logger "My hostname       : $host_name"
logger "Hostname IP       : $host_ip"
if [[ "$helo_name" != "$host_name" ]]; then
    logger "My HELO name      : $helo_name"
    logger "HELO name IP      : $helo_ip"
fi
logger "My public IP      : $public_ip"
logger "My public IP RDNS : $public_rnds"
