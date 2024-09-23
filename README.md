# insios/smarthost

A smarthost is an MTA (Mail Transfer Agent), or mail relay via which third
parties can send emails and have them forwarded to the recipient's email
servers.

## Description

This image allows you to run your own smarthost (smtp relay) for delivering
emails from your websites (transactional emails, subscriptions, notifications
etc), IOT devices (printers, sensors etc), and any other SMTP clients.

Supported features:
    [STARTTLS](https://en.wikipedia.org/wiki/STARTTLS),
    [SMTP AUTH](https://en.wikipedia.org/wiki/SMTP_Authentication),
    [DKIM](https://en.wikipedia.org/wiki/DomainKeys_Identified_Mail),
    [PROXY protocol](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt),
    Next hop smtp relay.

Based on alpine linux + postfix + openssl + cyrus-sasl + opendkim.

## TL;DR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration

### Via ENV variables

The simplest but less powerful way to configure smarthost.

| Name | Default | Example | Description |
| ---- | ------- | ------- | ----------- |
| `SH_HOSTNAME`         | `localhost.localdomain`   | `relay.mydomain.com`          | Hostname of smarthost which will be used as `EHLO` in SMTP header and in `Received: from [client] by [hostname]` mail heder |
| `SH_ALLOWED_NETWORKS` | `127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16`  | `0.0.0.0/0` | Coma or space delimited networks and IP addresses from which clients are allowed to connect and send emails |
| `SH_AUTH`             |                           | `user:password`               | Colon delimited username and password for smtp clients authorization |
| `SH_TLS_LEVEL`        |                           | `may`                         | `may` or `encrypt` |
| `SH_TLS_CRT`          |                           | `postfix.tls/tls.crt`         | relative to `/etc/smarthost` |
| `SH_TLS_KEY`          |                           | `postfix.tls/tls.key`         | relative to `/etc/smarthost` |
| `SH_RELAY_HOST`       |                           | `smtp-relay.gmail.com:587`    |  |
| `SH_RELAY_USERNAME`   |                           | `gmailuser`                   |  |
| `SH_RELAY_PASSWORD`   |                           | `gmailpassword`               |  |
| `SH_RELAY_TLS`        |                           | `yes`                         |  |
| `SH_VERBOSE`          |                           | `yes`                         |  |

### Via YAML files

The powerful and user-friendly way to configure smarthost.

### Via low-level configuration files

The most powerful for those who are familiar with postfix and opendkim.

## Helm chart

See [chart](chart)

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
