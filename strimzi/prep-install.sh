#!/usr/bin/env bash

kubectl create ns kafka

# prep
sed -i '' 's/namespace: .*/namespace: cflt-strimzi/' install/cluster-operator/*RoleBinding*.yaml
sed -i '' 's/namespace: .*/namespace: kafka/' install/cluster-operator/*RoleBinding*.yaml

kubectl create ns cp-project


# deploy

kubectl create -f install/cluster-operator/020-RoleBinding-strimzi-cluster-operator.yaml -n cp-project
kubectl create -f install/cluster-operator/031-RoleBinding-strimzi-cluster-operator-entity-operator-delegation.yaml -n cp-project

kubectl create -f install/cluster-operator/ -n kafka

kubectl apply -f kafka-persistent.yaml -n cp-project


$ helm upgrade -f values.yaml \
               --set kafka.bootstrapServers="cflt-kafka-bootstrap:9092" \
               --set replicaCount=2 \
               cp-schema-registry ./cp-helm-charts/charts/cp-schema-registry/
Release "cp-schema-registry" has been upgraded. Happy Helming!
NAME: cp-schema-registry
LAST DEPLOYED: Tue Jun 21 15:53:33 2022
NAMESPACE: cp-project
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
This chart installs a Confluent Kafka Schema Registry

https://github.com/confluentinc/schema-registry


helm upgrade -f values.yaml \
              --set kafka.bootstrapServers="cflt-kafka-bootstrap:9092" \
              --set replicaCount=1 \
              cp-control-center ./cp-helm-charts/charts/cp-control-center/
