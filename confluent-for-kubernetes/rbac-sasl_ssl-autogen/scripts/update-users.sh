#!/usr/bin/env bash

## Set namespace
kubens confluent-sssl

export MY_HOME=$(pwd)

## Update users

kubectl --namespace confluent create secret generic credential \
    --from-file=plain-users.json=$MY_HOME/creds-kafka-sasl-users.json \
    --from-file=digest-users.json=$MY_HOME/creds-zookeeper-sasl-digest-users.json \
    --from-file=digest.txt=$MY_HOME/creds-kafka-zookeeper-credentials.txt \
    --from-file=plain.txt=$MY_HOME/creds-client-kafka-sasl-user.txt \
    --from-file=basic.txt=$MY_HOME/creds-control-center-users.txt \
    --from-file=ldap.txt=$MY_HOME/ldap.txt \
    --save-config --dry-run=client -oyaml | kubectl apply -f -
