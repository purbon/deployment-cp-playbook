#!/usr/bin/env bash

kubectl create secret generic credential \
  --from-file=plain-users.json=./secrets/creds-kafka-sasl-users.json \
  --from-file=digest-users.json=./secrets/creds-zookeeper-sasl-digest-users.json \
  --from-file=digest.txt=./secrets/creds-kafka-zookeeper-credentials.txt \
  --from-file=plain.txt=./secrets/creds-client-kafka-sasl-user.txt \
  --from-file=basic.txt=./secrets/creds-control-center-users.txt \
  --from-file=ldap.txt=./secrets/ldap.txt \
  --namespace confluent


## RBAC 

kubectl create secret generic mds-token \
  --from-file=mdsPublicKey.pem=../assets/certs/mds-publickey.txt \
  --from-file=mdsTokenKeyPair.pem=../assets/certs/mds-tokenkeypair.txt \
  --namespace confluent

  # Kafka RBAC credential
  kubectl create secret generic mds-client \
    --from-file=bearer.txt=./secrets/bearer.txt \
    --namespace confluent
  # Control Center RBAC credential
  kubectl create secret generic c3-mds-client \
    --from-file=bearer.txt=./secrets/c3-mds-client.txt \
    --namespace confluent
  # Connect RBAC credential
  kubectl create secret generic connect-mds-client \
    --from-file=bearer.txt=./secrets/connect-mds-client.txt \
    --namespace confluent
  # Schema Registry RBAC credential
  kubectl create secret generic sr-mds-client \
    --from-file=bearer.txt=./secrets/sr-mds-client.txt \
    --namespace confluent
  # ksqlDB RBAC credential
  kubectl create secret generic ksqldb-mds-client \
    --from-file=bearer.txt=./secrets/ksqldb-mds-client.txt \
    --namespace confluent
  # Kafka Rest Proxy RBAC credential
  kubectl create secret generic krp-mds-client \
    --from-file=bearer.txt=./secrets/krp-mds-client.txt \
    --namespace confluent
  # Kafka REST credential
  kubectl create secret generic rest-credential \
    --from-file=bearer.txt=./secrets/bearer.txt \
    --from-file=basic.txt=./secrets/bearer.txt \
    --namespace confluent