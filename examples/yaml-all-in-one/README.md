# Configure via all-in-one YAML file

## Configuration files

| Path                              | Description                   |
| --------------------------------- | ----------------------------- |
| `./all-in-one.yaml`               | All config in one file        |

## Docker

```shell
docker run -d --restart unless-stopped \
    --name smarthost \
    -p 8587:587 -p 8586:586 \
    -v ./all-in-one.yaml:/etc/smarthost/yaml.d/all-in-one.yaml \
    insios/smarthost
```

## Helm

```shell
helm upgrade --install --atomic --cleanup-on-fail \
    --namespace smarthost --create-namespace \
    --set-file config.yaml.data.all-in-one_yaml=./all-in-one.yaml \
    smarthost oci://ghcr.io/insios/helm/smarthost
```
