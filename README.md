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
    Next hop smtp relay

Based on alpine linux + postfix + openssl + cyrus-sasl + opendkim

## TLTR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration

### ENV

Less powerful but simplest way to configure smarthost

| ENV name | Default | Description |
| --- | --- | --- |
| SH_VERBOSE |  |  |
| SH_HOSTNAME | localhost.localdomain |  |
| SH_ALLOWED_NETWORKS | 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 |  |
| SH_AUTH |  | `test:test` |
| SH_TLS_LEVEL |  | `may` or `encrypt` |
| SH_TLS_CRT |  | relative to /etc/smarthost |
| SH_TLS_KEY |  | relative to /etc/smarthost |
| SH_RELAY_HOST |  |  |
| SH_RELAY_USERNAME |  |  |
| SH_RELAY_PASSWORD |  |  |
| SH_RELAY_TLS |  |  |

### YAML

### conf files

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
