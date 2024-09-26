# Configure via YAML file and TLS files

## Configuration files

| Path                                  | Description                       |
| ------------------------------------- | --------------------------------- |
| `config/yaml.d/config.yaml`           | YAML config                       |
| `config/postfix.tls/tls.crt`          | Postfix TLS certificate           |
| `config/postfix.tls/tls.key`          | Postfix TLS private key           |
| `config/opendkim.keys/mydomain.key`   | DKIM private key for mydomain.com |

## Docker

```shell
docker run -d --restart unless-stopped \
    --name smarthost \
    -p 8587:587 -p 8586:586 \
    -v ./config:/etc/smarthost \
    insios/smarthost
```

## Helm

```shell
helm upgrade --install --atomic --cleanup-on-fail \
    --namespace smarthost --create-namespace \
    --set-file config.yaml.data.config_yaml=./config/yaml.d/config.yaml \
    --set-file config.postfix-tls.data.tls\\.crt=./config/postfix.tls/tls.crt \
    --set-file config.postfix-tls.data.tls\\.key=./config/postfix.tls/tls.key \
    --set-file config.opendkim-keys.data.mydomain\\.key=./config/opendkim.keys/mydomain.key \
    smarthost oci://ghcr.io/insios/helm/smarthost
```
