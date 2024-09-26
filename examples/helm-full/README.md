# Helm full example

## Configuration files

| Path                          | Description                       |
| ----------------------------- | --------------------------------- |
| `values.yaml`                 | Helm chart values                 |
| `yaml.d/config.yaml`          | General smarthost configuration   |
| `yaml.d/domains.yaml`         | Domains list                      |
| `yaml.d/users.yaml`           | Users list                        |
| `opendkim.keys/domain1.key`   | DKIM key for mydomain1.com        |
| `opendkim.keys/domain2.key`   | DKIM key for mydomain2.com        |

## Helm

```shell
helm upgrade --install --atomic --cleanup-on-fail \
    --namespace smarthost --create-namespace \
    -f ./values.yaml \
    --set-file config.yaml.data.config\\.yaml=./yaml.d/config.yaml \
    --set-file config.yaml.data.domains\\.yaml=./yaml.d/domains.yaml \
    --set-file config.yaml.data.users\\.yaml=./yaml.d/users.yaml \
    --set-file config.opendkim-keys.data.domain1\\.key=./opendkim.keys/domain1.key \
    --set-file config.opendkim-keys.data.domain2\\.key=./opendkim.keys/domain2.key \
    smarthost oci://ghcr.io/insios/helm/smarthost --version 1.0.0
```
