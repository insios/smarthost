# insios/smarthost

A smarthost is an mail transfer agent, or mail relay via which third parties can
send emails and have them forwarded on to the email recipient's email servers.

## Description

This image allows you...

## TLDR

```shell
docker run --rm --name smarthost -p 8587:587 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration
