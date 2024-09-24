# INSIOS/smarthost

A smarthost is an MTA (Mail Transfer Agent), or mail relay via which third parties can send emails and have them forwarded to the recipient's email servers.

## Description

This image allows you to run your own smarthost (smtp relay) for delivering emails from your websites and applications (transactional emails, subscriptions, notifications etc), IOT devices (printers/scanners, sensors etc) and any other SMTP clients.

Once started, the container will listen on standard submission port 587 and additional port 586 with PROXY protocol support.

Supported features:
    [STARTTLS](https://en.wikipedia.org/wiki/STARTTLS),
    [SMTP AUTH](https://en.wikipedia.org/wiki/SMTP_Authentication),
    [DKIM](https://en.wikipedia.org/wiki/DomainKeys_Identified_Mail),
    [PROXY protocol](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt),
    next-hop SMTP relay,
    [cert-manager](https://cert-manager.io/) when deploys to Kubernetes with Helm chart.

Based on alpine linux + postfix + openssl + cyrus-sasl + opendkim.

## TL;DR

```shell
docker run --rm --name smarthost -p 8587:587 -p 8586:586 insios/smarthost
```

```shell
helm upgrade --install smarthost oci://ghcr.io/insios/helm/smarthost
```

## Configuration

You can configure smarthost in three different ways - via ENV variables, via YAML files or via low-level configuration files.

### Defaults

* Hostname is `localhost.localdomain` which will be used in `EHLO` SMTP command and in `Received: from [client] by [hostname]` mail header
* Networks from which clients are allowed to connect and send emails: `127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16`
* No clients authentication
* No STARTTLS support
* No `From:` addresses restrictions
* No DKIM signatures
* No next-hop SMTP relay (direct delivery to recipient's MX servers)

### Configuration directories

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

The powerful and user-friendly way to configure smarthost. Mount one or more `*.yaml` or `*_yaml` files into `/etc/smarthost/yaml.d` directory with a content like:

```yaml
config:
  hostname: 'relay.mydomain.com'
  auth: true
  sender_restrictions: 'domain'
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
| `config.tls.crt`              | `''`                          | OR TLS certificate value |
| `config.tls.key_file`         | `'postfix.tls/tls.key'`       | Path to TLS private key file relative to `/etc/smarthost` (don't forget to mount this file) |
| `config.tls.key`              | `''`                          | OR TLS private key value |
| `config.relay`                | `{}`                          | The next-hop SMTP relay configuration parameters |
| `config.relay.host`           | `'smtp-relay.gmail.com:587'`  | The next-hop SMTP relay host and port |
| `config.relay.username`       | `'gmailuser'`                 | The next-hop SMTP relay user name |
| `config.relay.password`       | `'gmailpassword'`             | The next-hop SMTP relay password |
| `config.relay.tls`            | `true`                        | Use TLS for the next-hop SMTP relay |
| `config.verbose`              | `true`                        | Verbose postfix logging |
| `users`                       | `[]`                          | Users list    |
| `users[].name`                | `'user1'`                     | User name for authentication |
| `users[].password`            | `'password1'`                 | Password for authentication |
| `users[].allowed_from`        | `['noreply@mydomain.com']`    | If `config.sender_restrictions` is `email` - list of allowed `From:` emails in a form `abc@mydomain.com` or `@mydomain.com`. No restrictions for this user if empty. |
| `domains`                     | `[]`                          | Domains list  |
| `domains[].name`              | `'mydomain.com'`              | Domain name |
| `domains[].dkim`              | `{}`                          | DKIM configuration parameters for domain |
| `domains[].dkim.selector`     | `'myrelay'`                   | DKIM selector |
| `domains[].dkim.key_file`     | `'opendkim.keys/domain1.key'` | Path to DKIM private key file relative to `/etc/smarthost` (don't forget to mount this file) |
| `domains[].dkim.key`          | `''`                          | OR DKIM private key value |

### Configuration via low-level configuration files

The most powerful for those who are familiar with postfix and opendkim.

#### Postfix configuration

Mount one or more `*.conf` or `*_conf` files into `/etc/smarthost/postfix.d` directory with a content like:

```shell
# Verbose
-M -e submission/inet="submission inet n - n - - smtpd -v"

# Hostname
-e myhostname="relay.mydomain.com"
-e smtp_helo_name="relay.mydomain.com"

# STARTTLS
-e smtpd_tls_security_level="may"
-e smtpd_tls_cert_file="/etc/smarthost/postfix.tls/tls.crt"
-e smtpd_tls_key_file="/etc/smarthost/postfix.tls/tls.key"

# ...
```

Each line of these files will be threaded as command line arguments to `postconf` utility.

See [postconf](https://www.postfix.org/postconf.1.html),
    [main.cf](https://www.postfix.org/postconf.5.html),
    [master.cf](https://www.postfix.org/master.5.html).

#### OpenDKIM configuration

Mount `signingtable` and `keytable` files into `/etc/smarthost/opendkim` directory with a content like:

```config
# signingtable file
# [domain] [selector]._domainkey.[domain]
mydomain.com myrelay._domainkey.mydomain.com
```

```config
# keytable file
# [selector]._domainkey.[domain] [domain]:[selector]:/etc/smarthost/opendkim.keys/[keyfile]
myrelay._domainkey.mydomain.com mydomain.com:myrelay:/etc/smarthost/opendkim.keys/mydomain.key

```

See [opendkim docs](http://www.opendkim.org/docs.html)

#### Users list

Mount one or more `*.conf` or `*_conf` files into `/etc/smarthost/users.d` directory with a space delimited usernames and passwords like:

```config
# [username] [password]
user1       password1
username2   password2
```

## Helm chart

See [chart](chart)

## Examples

### Configure via all-in-one YAML file

See [examples/yaml-all-in-one](examples/yaml-all-in-one)

### Configure via YAML file and TLS files

See [examples/yaml-and-tls](examples/yaml-and-tls)

### Configure via YAML files per domain

See [examples/yaml-per-domain](examples/yaml-per-domain)

### Configure via ENV variables

See [examples/env](examples/env)

### Configure via low-level configuration files

See [examples/low-level](examples/low-level)

## Tips

### DKIM

[DomainKeys Identified Mail](https://en.wikipedia.org/wiki/DomainKeys_Identified_Mail) (DKIM) is an email authentication method designed to detect forged sender addresses in email (email spoofing), a technique often used in phishing and email spam.

To generate new private key and DNS TXT record for the domain you can use `opendkim-genkey` command (see [docs](http://www.opendkim.org/opendkim-genkey.8.html)):

```shell
opendkim-genkey -b 1024 -d mydomain.com -s myrelay
```

### SPF

[Sender Policy Framework](https://en.wikipedia.org/wiki/Sender_Policy_Framework) (SPF) is an email authentication method which ensures the sending mail server is authorized to originate mail from the email sender's domain.

If you already using SPF record in your domain or want to start using it, you have to add some keys for the SPF record like:

* `a:relay.mydomain.com` if your smarthost hostname `relay.mydomain.com`
* `ip4:12.34.56.78` if an [outbound public IP](#outbound-public-ip) of you smarthost container is `12.34.56.78` and its differs from `A` record of your smarthost domain `relay.mydomain.com`.

### DMARC

[Domain-based Message Authentication, Reporting and Conformance](https://en.wikipedia.org/wiki/DMARC) (DMARC) is an email authentication protocol that designed to give email domain owners the ability to protect their domain from unauthorized use, commonly known as email spoofing.

This protocol does not directly affect the settings of your smarthost, but allows you to further strengthen the protection of emails from your domains by instructing recipient servers on how to act with emails that have not passed verification through SPF and DKIM methods.

For example, `v=DMARC1; p=quarantine; adkim=s; aspf=s;` DMARC record tells mail servers of recipients that any emails that do not pass the validation according to DKIM and SPF records should be marked as spam.

Be careful - if you have added a DMARC record to your domain, but have not configured the smarthost and DKIM/SPF records correctly, then all emails sent through your smarthost will be marked as spam by recipients.

### External client's real IP and PROXY Protocol

In most cases, your smarthost container will be accessible for SMTP clients outside its subnet only through some proxy or load balancer. Thus, all connections to container's port 587 will come from the single IP address of this proxy/load balancer and the `config.allowed_networks` restrictions will not work correctly for such external clients. In addition, the `Received: from [client info]` email headers will contain information about the proxy, not the real client.

To solve this problem, you can use the [PROXY Protocol](https://www.haproxy.com/blog/use-the-proxy-protocol-to-preserve-a-clients-ip-address) and the corresponding container's port 586 that supports it.

For example, if you runs smarthost container with a docker command:

```shell
docker run --rm --name smarthost -p 8586:586 insios/smarthost
```

then, your haproxy configuration on the same host may be like:

```config
frontend smarthost
    bind 12.34.56.78:587
    mode tcp
    option tcplog
    use_backend smarthost-pp

backend smarthost-pp
    mode tcp
    server server1 127.0.0.1:8586 send-proxy
```

Or, if smarthost deployed to kubernetes with NodePort service on 30586 proxy protocol port, then haproxy configuration may be like:

```config
frontend smarthost
    bind 12.34.56.78:587
    mode tcp
    option tcplog
    use_backend smarthost-kube-pp

backend smarthost-kube-pp
    mode tcp
    server node1 192.168.0.10:30586 send-proxy
    server node2 192.168.0.20:30586 send-proxy
    server node3 192.168.0.30:30586 send-proxy
```

Or, if you are using any load balancer in you environment, then see the corresponded documentation for it about using a PROXY protocol.

### Outbound public IP

When a smarthost delivers emails to recipient's mail servers, it connects to them as a client via the SMTP protocol. In most cases, here will be used the public IP address of the server/node on which the smarthost container is running or the public IP of the NAT gateway of this server/node.

If the smarthost is launched via docker run, then you can control the public IP it uses for outgoing connections through the docker network configuration and the host's routing table.

If the smarthost is running in Kubernetes, then you need to configure the egress gateway, which depends on your Kubernetes engine and its CNI networking plugin.

### Proper network setup for smarthost

Ideally it should be, for example:

* Smarthost's hostname is `relay.mydomain.com`
* DNS `A` record of `relay.mydomain.com` is `12.34.56.78`
* Submission port `587` on this IP address `12.34.56.78` forwarded to smarthost's `587` port (or smarthost's `586` port via PROXY protocol)
* This IP address `12.34.56.78` also used by smarthost as a public IP for its outbound traffic
* Reverse DNS record for this IP `12.34.56.78` is `relay.mydomain.com`
* SPF DNS records of domains from which smarthost sends emails contains `a:relay.mydomain.com`
* Common name of smarthost's TLS certificate is `relay.mydomain.com`
