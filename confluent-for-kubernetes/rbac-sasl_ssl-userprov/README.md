# Deploy Confluent Platform with Confluent for Kubernetes

## Characteristics

* Role Base Access Control enabled
* SASL_SSL
* User provided certificates
* Managed Topics
* Managed RBAC role bindings
* Managed Connectors

```bash
$ kubectl get pods                                                                                                              2.7.0
NAME                                 READY   STATUS    RESTARTS   AGE
confluent-operator-5944b57b8-gl687   1/1     Running   0          66m
connect-0                            1/1     Running   1          51m
controlcenter-0                      1/1     Running   2          51m
kafka-0                              1/1     Running   0          51m
kafka-1                              1/1     Running   1          51m
kafka-2                              1/1     Running   1          51m
kafka-3                              1/1     Running   1          51m
kafkarestproxy-0                     1/1     Running   0          51m
ksqldb-0                             1/1     Running   3          51m
ldap-0                               1/1     Running   1          66m
schemaregistry-0                     1/1     Running   4          51m
zookeeper-0                          1/1     Running   0          51m
zookeeper-1                          1/1     Running   0          51m
zookeeper-2                          1/1     Running   0          51m
```

## Deployment steps

[![asciicast](https://asciinema.org/a/wYuBDaiqhuEMLsshHKt1N0Wtd.svg)](https://asciinema.org/a/wYuBDaiqhuEMLsshHKt1N0Wtd)

### Prepare your cluster for a namespaced operator deployment

```bash
mkdir -p cfk
helm pull confluentinc/confluent-for-kubernetes \
  --untar --untardir=cfk
kubectl apply -f cfk/confluent-for-kubernetes/crds

kubectl create namespace kafka-sasl-ssl-user
kubectl apply -f cfk-permissions.yaml
```

### Deploy Confluent for Kurberntes and OpenLDAP

```bash
kubens kafka-sasl-ssl-user
helm upgrade --install operator confluentinc/confluent-for-kubernetes \
             --set rbac=false \
             --set namespaced=true \
             --namespace kafka-sasl-ssl-user

## LDAP
helm upgrade --install -f ../assets/openldap/ldaps-rbac.yaml test-ldap ../assets/openldap --namespace kafka-sasl-ssl-user
```

### Create the necessary secrets

```bash

## Set namespace
kubens kafka-sasl-ssl-user

## Credentials and secrets

### TLS
export MY_HOME=$(pwd)

## Generate certificates

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/server

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/kafka-server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/kafka-server

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/controlcenter-server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/controlcenter-server

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/schemaregistry-server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/schemaregistry-server

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/connect-server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/connect-server

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/ksqldb-server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/ksqldb-server

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/zookeeper-server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/zookeeper-server

cfssl gencert -ca=$MY_HOME/../assets/certs/generated/ca.pem \
-ca-key=$MY_HOME/../assets/certs/generated/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/kafkarestproxy-server-domain.json | cfssljson -bare $MY_HOME/../assets/certs/generated/kafkarestproxy-server


## create secrets
kubectl create secret generic tls-group1 \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/server-key.pem

kubectl create secret generic tls-zookeeper \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/zookeeper-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/zookeeper-server-key.pem

kubectl create secret generic tls-kafka \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/kafka-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/kafka-server-key.pem

kubectl create secret generic tls-kafka-internal \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/kafka-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/kafka-server-key.pem

kubectl create secret generic tls-kafka-external \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/kafka-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/kafka-server-key.pem

kubectl create secret generic tls-controlcenter \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/controlcenter-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/controlcenter-server-key.pem

kubectl create secret generic tls-schemaregistry \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/schemaregistry-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/schemaregistry-server-key.pem

kubectl create secret generic tls-connect \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/connect-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/connect-server-key.pem

kubectl create secret generic tls-ksqldb \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/ksqldb-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/ksqldb-server-key.pem

kubectl create secret generic tls-kafkarestproxy \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/kafkarestproxy-server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/kafkarestproxy-server-key.pem


### Authentication
kubectl create secret generic credential \
  --from-file=plain-users.json=$MY_HOME/secrets/creds-kafka-sasl-users.json \
  --from-file=digest-users.json=$MY_HOME/secrets/creds-zookeeper-sasl-digest-users.json \
  --from-file=digest.txt=$MY_HOME/secrets/creds-kafka-zookeeper-credentials.txt \
  --from-file=plain.txt=$MY_HOME/secrets/creds-client-kafka-sasl-user.txt \
  --from-file=basic.txt=$MY_HOME/secrets/creds-control-center-users.txt \
  --from-file=ldap.txt=$MY_HOME/secrets/ldap.txt


### RBAC principals credentials
kubectl create secret generic mds-token \
  --from-file=mdsPublicKey.pem=$MY_HOME/../assets/certs/mds-publickey.txt \
  --from-file=mdsTokenKeyPair.pem=$MY_HOME/../assets/certs/mds-tokenkeypair.txt

# ssl secrets
kubectl create secret tls ca-pair-sslcerts \
    --cert=$MY_HOME/ca.pem \
    --key=$MY_HOME/ca-key.pem


# Kafka RBAC credential
kubectl create secret generic mds-client \
  --from-file=bearer.txt=$MY_HOME/secrets/bearer.txt

# Control Center RBAC credential
kubectl create secret generic c3-mds-client \
  --from-file=bearer.txt=$MY_HOME/secrets/c3-mds-client.txt

# Connect RBAC credential
kubectl create secret generic connect-mds-client \
  --from-file=bearer.txt=$MY_HOME/secrets/connect-mds-client.txt

# Schema Registry RBAC credential
kubectl create secret generic sr-mds-client \
  --from-file=bearer.txt=$MY_HOME/secrets/sr-mds-client.txt

# ksqlDB RBAC credential
kubectl create secret generic ksqldb-mds-client \
  --from-file=bearer.txt=$MY_HOME/secrets/ksqldb-mds-client.txt

# Kafka Rest Proxy RBAC credential
kubectl create secret generic krp-mds-client \
  --from-file=bearer.txt=$MY_HOME/secrets/krp-mds-client.txt

# Kafka REST credential
kubectl create secret generic rest-credential \
  --from-file=bearer.txt=$MY_HOME/secrets/bearer.txt \
  --from-file=basic.txt=$MY_HOME/secrets/bearer.txt
```

### Deploy Confluent for Kubernetes

```bash
$ kubectl apply -f confluent-platform.yaml
```

### Apply Confluent Role Bindings for Kafka Connect (example for cluster validation)

```bash
$ kubectl apply -f cfrb-admin.yaml
```

```bash
$ kubectl get cfrb                                                                                                              2.7.0
NAME                        STATUS    KAFKACLUSTERID           PRINCIPAL        ROLE             KAFKARESTCLASS                AGE
connect-cfrb                CREATED   G0o9kcBSSj-73cb2503ZFA   User:connect     ResourceOwner    kafka-sasl-ssl-user/default   45m
connect-cfrb-kafka          CREATED   G0o9kcBSSj-73cb2503ZFA   User:connect     ResourceOwner    kafka-sasl-ssl-user/default   45m
internal-connect-0          CREATED   G0o9kcBSSj-73cb2503ZFA   User:connect     SecurityAdmin    kafka-sasl-ssl-user/default   56m
internal-connect-1          CREATED   G0o9kcBSSj-73cb2503ZFA   User:connect     ResourceOwner    kafka-sasl-ssl-user/default   56m
internal-connect-2          CREATED   G0o9kcBSSj-73cb2503ZFA   User:connect     DeveloperWrite   kafka-sasl-ssl-user/default   56m
internal-controlcenter-0    CREATED   G0o9kcBSSj-73cb2503ZFA   User:c3          SystemAdmin      kafka-sasl-ssl-user/default   56m
internal-kafkarestproxy-0   CREATED   G0o9kcBSSj-73cb2503ZFA   User:krp         DeveloperWrite   kafka-sasl-ssl-user/default   56m
internal-kafkarestproxy-1   CREATED   G0o9kcBSSj-73cb2503ZFA   User:krp         ResourceOwner    kafka-sasl-ssl-user/default   56m
internal-ksqldb-0           CREATED   G0o9kcBSSj-73cb2503ZFA   User:ksql        ResourceOwner    kafka-sasl-ssl-user/default   56m
internal-ksqldb-1           CREATED   G0o9kcBSSj-73cb2503ZFA   User:ksql        ResourceOwner    kafka-sasl-ssl-user/default   56m
internal-ksqldb-2           CREATED   G0o9kcBSSj-73cb2503ZFA   User:ksql        DeveloperWrite   kafka-sasl-ssl-user/default   56m
internal-schemaregistry-0   CREATED   G0o9kcBSSj-73cb2503ZFA   User:sr          SecurityAdmin    kafka-sasl-ssl-user/default   56m
internal-schemaregistry-1   CREATED   G0o9kcBSSj-73cb2503ZFA   User:sr          ResourceOwner    kafka-sasl-ssl-user/default   56m
testadmin-rb                CREATED   G0o9kcBSSj-73cb2503ZFA   User:testadmin   ClusterAdmin     kafka-sasl-ssl-user/default   51m
testadmin-rb-connect        CREATED   G0o9kcBSSj-73cb2503ZFA   User:testadmin   SystemAdmin      kafka-sasl-ssl-user/default   51m
testadmin-rb-ksql           CREATED   G0o9kcBSSj-73cb2503ZFA   User:testadmin   ResourceOwner    kafka-sasl-ssl-user/default   51m
testadmin-rb-sr             CREATED   G0o9kcBSSj-73cb2503ZFA   User:testadmin   SystemAdmin      kafka-sasl-ssl-user/default   51m
```

### Deploy a custom connector

```bash
$ kubectl apply -f connector.yaml
```


### Verify

```bash
$ kubectl describe connector/datagen-local-01                                                                                   2.7.0
Name:         datagen-local-01
Namespace:    kafka-sasl-ssl-user
Labels:       <none>
Annotations:  <none>
API Version:  platform.confluent.io/v1beta1
Kind:         Connector
Metadata:
  Creation Timestamp:  2022-05-16T16:23:35Z
  Finalizers:
    connector.finalizers.platform.confluent.io
  Generation:  1
  Managed Fields:
    API Version:  platform.confluent.io/v1beta1
    Fields Type:  FieldsV1
    fieldsV1:
.... redacted ....
            f:kind:
            f:name:
            f:uid:
      f:status:
        f:tasksReady:
    Manager:    manager
    Operation:  Update
    Time:       2022-05-16T16:28:35Z
  Owner References:
    API Version:           platform.confluent.io/v1beta1
    Block Owner Deletion:  true
    Controller:            true
    Kind:                  Connect
    Name:                  connect
    UID:                   911406a9-a56e-4b4e-b3c8-f543fc7a32d6
  Resource Version:        69925
  UID:                     924d9935-96b3-4f1f-ae26-030ea80eadfc
Spec:
  Class:  io.confluent.kafka.connect.datagen.DatagenConnector
  Configs:
    Iterations:                      10000000
    kafka.topic:                     pageviews
    key.converter:                   org.apache.kafka.connect.storage.StringConverter
    max.interval:                    100
    Quickstart:                      pageviews
    value.converter:                 org.apache.kafka.connect.json.JsonConverter
    value.converter.schemas.enable:  false
  Connect Cluster Ref:
    Name:  connect
  Connect Rest:
    Authentication:
      Bearer:
        Secret Ref:  connect-mds-client
      Type:          bearer
  Task Max:          2
Status:
  Connect Rest Endpoint:  https://connect.kafka-sasl-ssl-user.svc.cluster.local:8083
  Connector State:        RUNNING
  Kafka Cluster ID:       G0o9kcBSSj-73cb2503ZFA
  Restart Policy:
    Max Retry:  10
    Type:       OnFailure
  State:        CREATED
  Tasks Ready:  2/2
  Worker ID:    connect-0.connect.kafka-sasl-ssl-user.svc.cluster.local:8083
Events:         <none>
```

```bash
$ kubectl get connector                                                                                                         2.7.0
NAME               STATUS    CONNECTORSTATUS   TASKS-READY   AGE
datagen-local-01   CREATED   RUNNING           2/2           46m
```

### Open Control Center

```bash
$ kubectl port-forward controlcenter-0 9021:9021                                                                                2.7.0
Forwarding from 127.0.0.1:9021 -> 9021
Forwarding from [::1]:9021 -> 9021
```
