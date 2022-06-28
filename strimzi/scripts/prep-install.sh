#!/usr/bin/env bash

kubectl create ns kafka
sed -i '' 's/namespace: .*/namespace: kafka/' install/cluster-operator/*RoleBinding*.yaml

kubectl create ns cp-project


# deploy

kubectl create -f install/cluster-operator/020-RoleBinding-strimzi-cluster-operator.yaml -n cp-project
kubectl create -f install/cluster-operator/031-RoleBinding-strimzi-cluster-operator-entity-operator-delegation.yaml -n cp-project

kubectl apply -f install/cluster-operator/ -n kafka

kubectl apply -f kafka-persistent.yaml -n cp-project


helm upgrade --install -f values.yaml \
               --set kafka.bootstrapServers="foo-kafka-bootstrap:9092" \
               --set replicaCount=2 \
               cp-schema-registry ./cp-helm-charts/charts/cp-schema-registry/

helm upgrade --install -f values.yaml \
              --set kafka.bootstrapServers="cflt-kafka-bootstrap:9092" \
              --set replicaCount=1 \
              cp-control-center ./cp-helm-charts/charts/cp-control-center/
