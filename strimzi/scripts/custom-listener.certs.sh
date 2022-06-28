#!/usr/bin/env bash


openssl genrsa -out ./assets/certs/generated/rootCAkey.pem 2048

openssl req -x509  -new -nodes \
  -key ./assets/certs/generated/rootCAkey.pem \
  -days 3650 \
  -out ./assets/certs/generated/cacerts.pem \
  -subj "/C=US/ST=CA/L=MVT/O=TestOrg/OU=Cloud/CN=TestCA"


cfssl gencert -ca=./assets/certs/generated/cacerts.pem \
-ca-key=./assets/certs/generated/rootCAkey.pem \
-config=./assets/certs/ca-config.json \
-profile=server ./assets/certs/component-certs/zookeeper-server-domain.json | cfssljson -bare ./assets/certs//generated/zookeeper-server

# Create Kafka server certificates
# Use the SANs listed in kafka-server-domain.json

cfssl gencert -ca=./assets/certs/generated/cacerts.pem \
-ca-key=./assets/certs/generated/rootCAkey.pem \
-config=./assets/certs/ca-config.json \
-profile=server ./assets/certs/component-certs/kafka-server-domain.json | cfssljson -bare ./assets/certs//generated/kafka-server


kubectl create secret generic my-secret \
        --from-file=./assets/certs/generated/kafka-server-key.pem \
        --from-file=./assets/certs/generated/kafka-server.pem
