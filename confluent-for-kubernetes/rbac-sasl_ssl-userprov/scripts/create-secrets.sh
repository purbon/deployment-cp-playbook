#!/usr/bin/env bash


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


### RBAC princials credentials
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
