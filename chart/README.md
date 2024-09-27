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
| affinity | object | `{}` | Affinity gives you more control over the Node selection logic. See [docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) |
| autoscaling.enabled | bool | `false` | Enable PODs autoscaling |
| autoscaling.maxReplicas | int | `100` | See [docs](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/horizontal-pod-autoscaler-v2/) |
| autoscaling.minReplicas | int | `1` | See [docs](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/horizontal-pod-autoscaler-v2/) |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | See [docs](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/horizontal-pod-autoscaler-v2/) |
| config.env.data | object | `{}` | Environment variables |
| config.env.existingName | string | `nil` | Existing secret name for environment variables |
| config.opendkim-keys.data | object | `{}` | Opendkim private keys files |
| config.opendkim-keys.existingName | string | `nil` | Existing secret name for opendkim private keys files |
| config.opendkim.data | object | `{}` | Opendkim `signingtable` and `keytable` files |
| config.opendkim.existingName | string | `nil` | Existing secret name for opendkim `signingtable` and `keytable` files |
| config.postfix-tls.data | object | `{}` | Postfix TLS `tls.crt` and `tls.key` files |
| config.postfix-tls.existingName | string | `nil` | Existing secret name for postfix TLS `tls.crt` and `tls.key` files |
| config.postfix.data | object | `{}` | Postfix low-level configuration files |
| config.postfix.existingName | string | `nil` | Existing secret name for postfix low-level configuration files |
| config.users.data | object | `{}` | Low-level usernames and passwords |
| config.users.existingName | string | `nil` | Existing secret name for low-level usernames and passwords |
| config.yaml.data | object | `{}` | YAML configuration files |
| config.yaml.existingName | string | `nil` | Existing secret name for YAML configuration files |
| envFrom | list | `[]` | Additional ENV from Secrets or ConfigMaps on the output Deployment definition. |
| fullnameOverride | string | `""` | Overrides the full prefix of resource names |
| image.pullPolicy | string | `"IfNotPresent"` | See [docs](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy) |
| image.repository | string | `"insios/smarthost"` | The image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[]` | See [docs](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod) |
| livenessProbe.exec | object | `{"command":["postfix","status"]}` | Command to check |
| livenessProbe.failureThreshold | int | `1` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| livenessProbe.initialDelaySeconds | int | `30` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| livenessProbe.periodSeconds | int | `60` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| livenessProbeEnabled | bool | `true` | Enable [Liveness Probe](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/#liveness-probe) |
| nameOverride | string | `""` | Overrides the Helm chart name used to construct resource names |
| nodeSelector | object | `{}` | You can add the nodeSelector here and specify the node labels you want the target node to have. See [docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistence.accessMode | string | `"ReadWriteOnce"` | See [docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) |
| persistence.enabled | bool | `false` | Enable persistence for `/var/spool/postfix` directory |
| persistence.existingClaim | string | `""` | See [docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) |
| persistence.size | string | `"1Gi"` | See [docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) |
| persistence.storageClass | string | `""` | See [docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) |
| podAnnotations | object | `{}` | Additional annotations for POD |
| podLabels | object | `{}` | Additional labels for POD |
| podSecurityContext | object | `{}` | Security context for POD, see [docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod) |
| readinessProbe.failureThreshold | int | `1` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| readinessProbe.initialDelaySeconds | int | `30` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| readinessProbe.periodSeconds | int | `10` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| readinessProbe.tcpSocket | object | `{"port":"smtpd"}` | Port to check |
| readinessProbeEnabled | bool | `false` | Enable [Readiness Probe](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/#readiness-probe) |
| replicaCount | int | `1` | Number of PODs to load balance between |
| resources | object | `{}` | Resource management. See [docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) |
| securityContext | object | `{}` | Security context for container, see [docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) |
| service.create | bool | `true` | Create service for submission port 587 |
| service.port | int | `587` | Submission service port |
| service.type | string | `"ClusterIP"` | See [docs](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| servicePP.create | bool | `true` | Create service for submission port 586 with PROXY protocol |
| servicePP.port | int | `586` | PROXY protocol service port |
| servicePP.type | string | `"ClusterIP"` | See [docs](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) |
| startupProbe.failureThreshold | int | `10` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| startupProbe.periodSeconds | int | `3` | See [docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| startupProbe.tcpSocket | object | `{"port":"smtpd"}` | Port to check |
| startupProbeEnabled | bool | `true` | Enable [Startup Probe](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/#startup-probe) |
| tolerations | list | `[]` | Tolerations allow the scheduler to schedule pods with matching taints See [docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. See [docs](https://kubernetes.io/docs/concepts/storage/volumes/) |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. See [docs](https://kubernetes.io/docs/concepts/storage/volumes/) |

> All values table autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
