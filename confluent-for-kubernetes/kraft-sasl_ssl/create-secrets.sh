#!/usr/bin/env bash

openssl genrsa -out ./ca-key.pem 2048

openssl req -new -key ./ca-key.pem -x509 \
  -days 1000 \
  -out ./ca.pem \
  -subj "/C=US/ST=CA/L=MountainView/O=Confluent/OU=Operator/CN=TestCA"


kubectl create secret tls ca-pair-sslcerts \
  --cert=./ca.pem \
  --key=./ca-key.pem \
  -n confluent


kubectl create -n confluent secret generic credential \
    --from-file=plain.txt=./secrets/plain.txt \
    --from-file=plain-users.json=./secrets/plain-users.json \
    --from-file=basic.txt=./secrets/basic.txt


kubectl create secret generic credential \
  --save-config \
  --dry-run=client \
  --from-file=plain.txt=./secrets/plain.txt \
  --from-file=plain-users.json=./secrets/plain-users.json \
  --from-file=basic.txt=./secrets/basic.txt \
  -o yaml | kubectl apply -f -


kubectl create -n confluent secret generic connect-credential \
    --from-file=plain.txt=./secrets/connect-plain.txt


kubectl create secret generic confluent-license2 \
  --from-file=license.txt=./secrets/license.txt 