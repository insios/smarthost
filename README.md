# insios/smarthost

A smarthost is an MTA (Mail Transfer Agent), or mail relay via which third
parties can send emails and have them forwarded to the recipient's email
servers.

## Description

This image allows you to run your own smarthost (smtp relay) for delivering
emails from your websites (transactional emails, subscriptions, notifications
etc), IOT devices (printers, sensors etc), and so on.

Supported features:
    [STARTTLS](https://en.wikipedia.org/wiki/STARTTLS),
    [SMTP AUTH](https://en.wikipedia.org/wiki/SMTP_Authentication),
    [DKIM](https://en.wikipedia.org/wiki/DomainKeys_Identified_Mail),
    [Proxy Protocol](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt),
    Next hop smtp relay.

Based on alpine linux + postfix + openssl + cyrus-sasl + opendkim.

## TLTR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration

### Via ENV variables

The simplest but less powerful way to configure smarthost.

<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Default</th>
            <th>Example</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
<td>SH_HOSTNAME</td>
<td>localhost.localdomain</td>
<td>relay.mydomain.com</td>
<td>

Description

</td>
        </tr>
        <tr>
<td>SH_ALLOWED_NETWORKS</td>
<td>127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16</td>
<td>0.0.0.0/0</td>
<td>

Description

</td>
        </tr>
        <tr>
<td>SH_AUTH</td>
<td></td>
<td>testuser:testpassword</td>
<td></td>
        </tr>
        <tr>
<td>SH_TLS_LEVEL</td>
<td></td>
<td>may</td>
<td>

`may` or `encrypt`

</td>
        </tr>
        <tr>
<td>SH_TLS_CRT</td>
<td></td>
<td>postfix.tls/tls.crt</td>
<td>relative to /etc/smarthost</td>
        </tr>
        <tr>
<td>SH_TLS_KEY</td>
<td></td>
<td>postfix.tls/tls.key</td>
<td>relative to /etc/smarthost</td>
        </tr>
        <tr>
<td>SH_RELAY_HOST</td>
<td></td>
<td>smtp-relay.gmail.com:587</td>
<td></td>
        </tr>
        <tr>
<td>SH_RELAY_USERNAME</td>
<td></td>
<td>testuser</td>
<td></td>
        </tr>
        <tr>
<td>SH_RELAY_PASSWORD</td>
<td></td>
<td>testpassword</td>
<td></td>
        </tr>
        <tr>
<td>SH_RELAY_TLS</td>
<td></td>
<td>yes</td>
<td></td>
        </tr>
        <tr>
<td>SH_VERBOSE</td>
<td></td>
<td>yes</td>
<td></td>
        </tr>
    </tbody>
</table>

### Via YAML files

### Via different conf files

## Helm chart

See [chart README.md](chart)

## Examples

### Example 1

### Example 2

### Example 3

## Tips

### DKIM

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

### SPF

### DMARC

### Reverse DNS

### Proxy Protocol
