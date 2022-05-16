#!/usr/bin/env bash

## Set namespace
kubens kafka-sasl-ssl

export MY_HOME=$(pwd)
kubectl apply -f $MY_HOME/resources/zookeeper.yaml
kubectl apply -f $MY_HOME/resources/kafka.yaml
kubectl apply -f $MY_HOME/resources/connect.yaml

kubectl apply -f $MY_HOME/resources/controlcenter.yaml
kubectl apply -f $MY_HOME/resources/connect.yaml
kubectl apply -f $MY_HOME/resources/ksqldb.yaml
kubectl apply -f $MY_HOME/resources/schemaregistry.yaml



#kubectl apply -f $MY_HOME/confluent-platform-production-mtls.yaml


### Troubleshooting, get events

# kubectl get events --namespace confluent
# Warning  KeyInSecretRefIssue  kafka/kafka  required key [ldap.txt] missing in secretRef [credential] for auth type [ldap_simple]
