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

* Hostname is `localhost.localdomain` which will be used in `EHLO` SMTP command and in `Received: from [client] by [hostname]` mail header
* Networks from which clients are allowed to connect and send emails: `127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16`
* No clients authentication
* No STARTTLS support
* No `From:` addresses restrictions
* No DKIM signatures
* No next-hop SMTP relay (direct delivery to recipient's MX servers)

You can configure smarthost in three different ways - via ENV variables, via YAML files or via low-level configuration files.

Configuration directories:

| Path                            | Description                   |
| ------------------------------- | ----------------------------- |
| `/etc/smarthost/yaml.d`         | Directory for YAML configuration files |
| `/etc/smarthost/postfix.d`      | Directory for postfix low-level configuration files |
| `/etc/smarthost/postfix.tls`    | Directory for postfix TLS certificate and private key |
| `/etc/smarthost/opendkim`       | Directory for opendkim low-level configuration files |
| `/etc/smarthost/opendkim.keys`  | Directory for opendkim private keys |
| `/etc/smarthost/users.d`        | Directory for low-level configuration users list |

### Configuration via ENV variables

The simplest but less powerful way to configure smarthost.

| Name                  | Example value                 | Description |
| --------------------- | ----------------------------- | ----------- |
| `SH_HOSTNAME`         | `relay.mydomain.com`          | Hostname of smarthost which will be used in `EHLO` SMTP command and in `Received: from [client] by [hostname]` mail header |
| `SH_ALLOWED_NETWORKS` | `0.0.0.0/0` | Coma or space delimited networks and IP addresses from which clients are allowed to connect and send emails |
| `SH_AUTH`             | `user:password`               | Colon delimited username and password for clients authentication |
| `SH_TLS_LEVEL`        | `may`                         | The SMTP TLS security level for communicating with clients. Empty value - STARTTLS not allowed, `may` - optional STARTTLS, `encrypt` - STARTTLS required |
| `SH_TLS_CRT`          | `postfix.tls/tls.crt`         | Path to TLS certificate file relative to `/etc/smarthost` (don't forget to mount this file). If `SH_TLS_LEVEL` is not empty and no certificate file provided here then new self-signed certificate and key will be generated at startup automatically |
| `SH_TLS_KEY`          | `postfix.tls/tls.key`         | Path to TLS private key file relative to `/etc/smarthost` (don't forget to mount this file) |
| `SH_RELAY_HOST`       | `smtp-relay.gmail.com:587`    | The next-hop SMTP relay host and port |
| `SH_RELAY_USERNAME`   | `gmailuser`                   | The next-hop SMTP relay user name |
| `SH_RELAY_PASSWORD`   | `gmailpassword`               | The next-hop SMTP relay password |
| `SH_RELAY_TLS`        | `true`                        | Use TLS for the next-hop SMTP relay |
| `SH_VERBOSE`          | `true`                        | Verbose postfix logging |

### Configuration via YAML files

The powerful and user-friendly way to configure smarthost. Mount one or more yaml files into `/etc/smarthost/yaml.d` directory with a content like:

```yaml
config:
  hostname: 'relay.mydomain.com'
  auth: true
  tls:
    level: 'may'

users:
  - name: 'user1'
    password: 'password1'
  - name: 'user2'
    password: 'password2'

domains:
  - name: 'mydomain.com'
  - name: 'mydomain.io'
```

| Name                          | Example value                 | Description   |
| ----------------------------- | ----------------------------- | ------------- |
| `config`                      | `{}`                          | Configuration parameters |
| `config.hostname`             | `'relay.mydomain.com'`        | Hostname of smarthost which will be used in `EHLO` SMTP command and in `Received: from [client] by [hostname]` mail header |
| `config.allowed_networks`     | `['0.0.0.0/0']`               | Array of networks and IP addresses from which clients are allowed to connect and send emails |
| `config.auth`                 | `true`                        | Enable clients authentication |
| `config.sender_restrictions`  | `'email'`                     | Enable clients `From:` restrictions: `domain` - allow only listed domains or `email` - allow only listed emails |
| `config.tls`                  | `{}`                          | STARTTLS configuration parameters |
| `config.tls.level`            | `'may'`                       | The SMTP TLS security level for communicating with clients. Empty value - STARTTLS not allowed, `may` - optional STARTTLS, `encrypt` - STARTTLS required |
| `config.tls.crt_file`         | `'postfix.tls/tls.crt'`       | Path to TLS certificate file relative to `/etc/smarthost` (don't forget to mount this file). If `config.tls.level` is not empty and no certificate provided then new self-signed certificate and key will be generated at startup automatically |
| `config.tls.key_file`         | `'postfix.tls/tls.key'`       | Path to TLS private key file relative to `/etc/smarthost` (don't forget to mount this file) |
| `config.tls.crt`              | `''`                          | TLS certificate value |
| `config.tls.key`              | `''`                          | TLS private key value |
| `config.relay`                | `{}`                          | The next-hop SMTP relay configuration parameters |
| `config.relay.host`           | `'smtp-relay.gmail.com:587'`  | The next-hop SMTP relay host and port |
| `config.relay.username`       | `'gmailuser'`                 | The next-hop SMTP relay user name |
| `config.relay.password`       | `'gmailpassword'`             | The next-hop SMTP relay password |
| `config.relay.tls`            | `true`                        | Use TLS for the next-hop SMTP relay |
| `config.verbose`              | `true`                        | Verbose postfix logging |
| `users`                       | `[]`                          | Users list    |
| `users[].name`                | `'user1'`                     | User name for authentication |
| `users[].password`            | `'password1'`                 | Password for authentication |
| `users[].allowed_from`        | `['noreply@mydomain.com']`    | If `config.auth` is `true` - list of allowed `From:` emails in a form `noreply@mydomain.com` or `@mydomain.com`. No restrictions if empty. |
| `domains`                     | `[]`                          | Domains list  |
| `domains[].name`              | `'mydomain.com'`              | Domain name |
| `domains[].dkim`              | `{}`                          | DKIM configuration parameters for domain |
| `domains[].dkim.selector`     | `'myrelay'`                   | DKIM selector |
| `domains[].dkim.key_file`     | `'opendkim.keys/domain1.key'` | Path to DKIM private key file relative to `/etc/smarthost` (don't forget to mount this file) |
| `domains[].dkim.key`          | `''`                          | DKIM private key value |

### Configuration via low-level configuration files

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

### PROXY Protocol

### Outbound IP

### Reverse DNS
