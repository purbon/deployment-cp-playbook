#!/usr/bin/env bash

openssl s_client -showcerts -servername pkc-dopkmo.europe-west3.gcp.confluent.cloud \
-connect pkc-dopkmo.europe-west3.gcp.confluent.cloud:443  < /dev/null

kubectl -n confluent create secret generic ccloud-tls-certs \
--from-file=fullchain.pem=fullchain.pem --from-file=cacerts.pem=cacert.pem