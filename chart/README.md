# INSIOS/smarthost Helm chart

A smarthost is an MTA (Mail Transfer Agent), or mail relay via which third parties can send emails and have them forwarded to the recipient's email servers.

See [https://github.com/insios/smarthost](https://github.com/insios/smarthost)

## TL;DR

```shell
helm upgrade --install -f ./values.yaml smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration details

### Configuration secrets

For each smarthost configuration directory, there is a corresponding secret that can contain files for that directory within its `data` key. See [https://github.com/insios/smarthost#configuration-directories](https://github.com/insios/smarthost#configuration-directories)

| Values key                | Configuration directory           | Description                   |
| ------------------------- | --------------------------------- | ----------------------------- |
| `config.yaml`             | `/etc/smarthost/yaml.d`           | Secret for YAML configuration files |
| `config.postfix`          | `/etc/smarthost/postfix.d`        | Secret for postfix low-level configuration files |
| `config.postfix-tls`      | `/etc/smarthost/postfix.tls`      | Secret for postfix TLS certificate and private key |
| `config.opendkim`         | `/etc/smarthost/opendkim`         | Secret for opendkim low-level configuration files |
| `config.opendkim-keys`    | `/etc/smarthost/opendkim.keys`    | Secret for opendkim private keys |
| `config.users`            | `/etc/smarthost/users.d`          | Secret for low-level configuration users list |
| `config.env`              | -                                 | Secret for the container's environment variables |

### Configuration via ENV variables

See [https://github.com/insios/smarthost#configuration-via-env-variables](https://github.com/insios/smarthost#configuration-via-env-variables)

```yaml
# Your values.yaml 
config:
  env:
    data:
      SH_HOSTNAME: 'relay.mydomain.com'
      SH_ALLOWED_NETWORKS: '0.0.0.0/0'
      SH_AUTH: 'user:password'
      SH_TLS_LEVEL: 'may'
```

### Configuration via YAML files

See [https://github.com/insios/smarthost#configuration-via-yaml-files](https://github.com/insios/smarthost#configuration-via-yaml-files)

```yaml
# Your values.yaml 
config:
  yaml:
    data:
      smarthost.yaml:
        config:
          hostname: 'relay.mydomain.com'
          auth: true
          sender_restrictions: 'domain'
          tls:
            level: 'may'
        users:
          - name: 'user'
            password: 'password'
        domains:
          - name: 'mydomain.com'
```

OR yaml as a string

```yaml
# Your values.yaml 
config:
  yaml:
    data:
      smarthost.yaml: |
        config:
          hostname: 'relay.mydomain.com'
          auth: true
          sender_restrictions: 'domain'
          tls:
            level: 'may'
        users:
          - name: 'user'
            password: 'password'
        domains:
          - name: 'mydomain.com'
```

OR multiple yaml files

```yaml
# Your values.yaml 
config:
  yaml:
    data:
      comfig.yaml: |
        config:
          hostname: 'relay.mydomain.com'
          auth: true
          sender_restrictions: 'domain'
          tls:
            level: 'may'
      users.yaml: |
        users:
          - name: 'user1'
            password: 'password1'
          - name: 'user2'
            password: 'password2'
      domains.yaml: |
        domains:
          - name: 'mydomain1.com'
          - name: 'mydomain2.com'
```

OR yaml files per domain

```yaml
# Your values.yaml 
config:
  yaml:
    data:
      comfig.yaml: |
        config:
          hostname: 'relay.mydomain.com'
          auth: true
          sender_restrictions: 'email'
          tls:
            level: 'may'
      domain1.yaml: |
        domains:
          - name: 'mydomain1.com'
        users:
          - name: 'user1'
            password: 'password1'
            allowed_from:
              - '@mydomain1.com'
      domain2.yaml: |
        domains:
          - name: 'mydomain2.com'
        users:
          - name: 'user2'
            password: 'password2'
            allowed_from:
              - '@mydomain2.com'
```

### Configuration via low-level configuration files

See [https://github.com/insios/smarthost#configuration-via-low-level-configuration-files](https://github.com/insios/smarthost#configuration-via-low-level-configuration-files)

```yaml
# Your values.yaml 
config:
  postfix:
    data:
      master.conf: |
        # Verbose
        -M -e submission/inet="submission inet n - n - - smtpd -v"
      main.conf: |
        -e myhostname="relay.mydomain.com"
        -e smtp_helo_name="relay.mydomain.com"
        -e smtpd_tls_security_level="may"
        -e smtpd_sasl_auth_enable="yes"
        -e smtpd_client_restrictions="permit_sasl_authenticated, reject"
  users:
    data:
      users.conf: |
        user1    password1
        user2    password2
```

### Cert-Manager TLS certificate

The `postfix-tls` secret configuration has a `cert-manager` key that can contain parameters for the `Certificate` resource. See [https://cert-manager.io/docs/usage/certificate/](https://cert-manager.io/docs/usage/certificate/)

```yaml
# Your values.yaml 
config:
  postfix-tls:
    cert-manager:
      commonName: 'relay.mydomain.com'
      issuerRef:
        kind: ClusterIssuer
        name: letsencrypt-production
```

> [!IMPORTANT]
> If the certificate is to be issued via any ACME issuer (for example, Let's Encrypt), it is necessary for `HTTP` port `80` of the `relay.mydomain.com` domain to route to the ingress controller of the same cluster.

### Existing secrets

If the smarthost configuration is completely or partially outside the scope of the Helm deployment, then each secret can have a corresponding `existingName` key.

```yaml
# Your values.yaml 
config:
  postfix-tls:
    existingName: 'my-postfix-tls'
  opendkim-keys:
    existingName: 'my-dkim-keys'
```

### Full example

See [https://github.com/insios/examples/helm-full](https://github.com/insios/examples/helm-full)

## All values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| config.env.data | object | `{}` |  |
| config.opendkim-keys.data | object | `{}` |  |
| config.opendkim.data | object | `{}` |  |
| config.postfix-tls.data | object | `{}` |  |
| config.postfix.data | object | `{}` |  |
| config.users.data | object | `{}` |  |
| config.yaml.data | object | `{}` |  |
| envFrom | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"insios/smarthost"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| livenessProbe.exec.command[0] | string | `"postfix"` |  |
| livenessProbe.exec.command[1] | string | `"status"` |  |
| livenessProbe.failureThreshold | int | `1` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `60` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClass | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.create | bool | `true` |  |
| service.port | int | `587` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| servicePP.create | bool | `true` |  |
| servicePP.port | int | `586` |  |
| servicePP.type | string | `"ClusterIP"` |  |
| startupProbe.failureThreshold | int | `10` |  |
| startupProbe.periodSeconds | int | `3` |  |
| startupProbe.tcpSocket.port | string | `"smtpd"` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

> All values table autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
