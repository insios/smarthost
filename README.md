# insios/smarthost

A smarthost is an MTA (Mail Transfer Agent), or mail relay via which third
parties can send emails and have them forwarded to the recipient's email
servers.

## Description

This image allows you to run your own smarthost smtp relay for delivering emails
from your websites (transactional emails, subscriptions, notifications etc),
IOT devices (printers, sensors etc), and so on.

Features: TLS, Auth, DKIM, relay, Proxy Protocol

Based on alpine linux + postfix + openssl + cyrus-sasl + opendkim

## TLDR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration

### ENV

Less powerful but simplest way

| ENV name | Default | Description |
| --- | --- | --- |
| SH_VERBOSE |  |  |
| SH_HOSTNAME |  |  |
| SH_ALLOWED_NETWORKS |  |  |
| SH_AUTH |  |  |
| SH_TLS_LEVEL |  |  |
| SH_TLS_CRT |  |  |
| SH_TLS_KEY |  |  |
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
