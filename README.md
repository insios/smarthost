# INSIOS/smarthost

A smarthost is an MTA (Mail Transfer Agent), or mail relay via which third parties can send emails and have them forwarded to the recipient's email servers.

## Description

This image allows you to run your own smarthost (smtp relay) for delivering emails from your websites (transactional emails, subscriptions, notifications etc), IOT devices (printers/scanners, sensors etc) and any other SMTP clients.

Supported features:
    [STARTTLS](https://en.wikipedia.org/wiki/STARTTLS),
    [SMTP AUTH](https://en.wikipedia.org/wiki/SMTP_Authentication),
    [DKIM](https://en.wikipedia.org/wiki/DomainKeys_Identified_Mail),
    [PROXY protocol](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt),
    Next-hop SMTP relay.

Based on alpine linux + postfix + openssl + cyrus-sasl + opendkim.

## TL;DR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration

By default:

* Hostname is `localhost.localdomain` which will be used as `EHLO` in SMTP header and in `Received: from [client] by [hostname]` mail heder
* Networks from which clients are allowed to connect and send emails: `127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16`
* No clients authorization
* No STARTTLS support for clients
* Any `From:` addresses allowed
* No DKIM signatures
* No next-hop SMTP relay (direct delivery to recipient's MX servers)

You can configure smarthost in three different ways - via ENV variables, via YAML files or via low-level configuration files.

### Via ENV variables

The simplest but less powerful way to configure smarthost.

| Name | Example value | Description |
| ---- | ------- | ----------- |
| `SH_HOSTNAME`         | `relay.mydomain.com`          | Hostname of smarthost which will be used as `EHLO` in SMTP header and in `Received: from [client] by [hostname]` mail heder. By default: `localhost.localdomain` |
| `SH_ALLOWED_NETWORKS` | `0.0.0.0/0` | Coma or space delimited networks and IP addresses from which clients are allowed to connect and send emails. By default: `127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16` |
| `SH_AUTH`             | `user:password`               | Colon delimited username and password for SMTP authorization of clients |
| `SH_TLS_LEVEL`        | `may`                         | The SMTP TLS security level. Empty value - TLS will not be used, `may` - announce STARTTLS support to remote SMTP clients, but do not require that clients use TLS encryption, `encrypt` - announce STARTTLS support to remote SMTP clients, and reject all plaintext commands |
| `SH_TLS_CRT`          | `postfix.tls/tls.crt`         | Path to TLS certificate file relative to `/etc/smarthost` (don't forget to mount this file) |
| `SH_TLS_KEY`          | `postfix.tls/tls.key`         | Path to TLS private key file relative to `/etc/smarthost` (don't forget to mount this file) |
| `SH_RELAY_HOST`       | `smtp-relay.gmail.com:587`    | The next-hop SMTP relay host and port |
| `SH_RELAY_USERNAME`   | `gmailuser`                   | The next-hop SMTP relay user name |
| `SH_RELAY_PASSWORD`   | `gmailpassword`               | The next-hop SMTP relay password |
| `SH_RELAY_TLS`        | `yes`                         | Use TLS for the next-hop SMTP relay |
| `SH_VERBOSE`          | `yes`                         | Verbose postfix logging |

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
