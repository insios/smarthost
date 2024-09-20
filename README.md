# insios/smarthost

A smarthost is an MTA (Mail Transfer Agent), or mail relay via which third
parties can send emails and have them forwarded on to the recipient's email
servers.

## Description

This image allows you...

Based on alpine + postfix + openssl + cyrus-sasl + opendkim

Features: TLS, Auth, DKIM, relay, Proxy Protocol

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

## TLDR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration

### ENV

### YAML

### conf files

## Helm chart

See chart [README.md](chart)

## Examples

### Example 1

### Example 2

### Example 3

## Tips

### DKIM

### SPF

### DMARC

### Proxy Protocol
