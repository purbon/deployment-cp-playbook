#!/usr/bin/env bash


## Set namespace
kubens ccloud-ksql

#openssl genrsa -out ./ca-key.pem 2048

#openssl req -new -key ./ca-key.pem -x509 \
#  -days 1000 \
#  -out ./ca.pem \
#  -subj "/C=US/ST=CA/L=MountainView/O=Confluent/OU=Operator/CN=TestCA"


kubectl create secret tls ca-pair-sslcerts \
  --cert=./ca.pem \
  --key=./ca-key.pem \
  -n ccloud-ksql


## Authentication credentials

kubectl create secret generic cloud-plain \
  --from-file=plain.txt=secrets/creds-client-kafka-sasl-user.txt

kubectl create secret generic cloud-sr-access \
  --from-file=basic.txt=secrets/creds-schemaRegistry-user.txt

kubectl create secret generic control-center-user \
  --from-file=basic.txt=secrets/creds-control-center-users.txt


## Credentials and secrets

### TLS
export MY_HOME=$(pwd)

cfssl gencert -ca=$MY_HOME/ca.pem \
-ca-key=$MY_HOME/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/ksqldb-server-domain.json | cfssljson -bare $MY_HOME/generated/ksqldb-server

cfssl gencert -ca=$MY_HOME/ca.pem \
-ca-key=$MY_HOME/ca-key.pem \
-config=$MY_HOME/../assets/certs/ca-config.json \
-profile=server $MY_HOME/../assets/certs/component-certs/controlcenter-server-domain.json | cfssljson -bare $MY_HOME/generated/controlcenter-server


kubectl create secret generic ksqldb-secret \
  --from-file=fullchain.pem=$MY_HOME/generated/ksqldb-server.pem \
  --from-file=cacerts.pem=$MY_HOME/ca-le.pem \
  --from-file=privkey.pem=$MY_HOME/generated/ksqldb-server-key.pem 

kubectl create secret generic c3-secret \
  --from-file=fullchain.pem=$MY_HOME/generated/controlcenter-server.pem \
  --from-file=cacerts.pem=$MY_HOME/ca-le.pem \
  --from-file=privkey.pem=$MY_HOME/generated/controlcenter-server-key.pem 