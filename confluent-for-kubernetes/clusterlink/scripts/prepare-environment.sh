#!/usr/bin/env bash


## Operator
kubectl create namespace confluent

helm upgrade --install confluent-operator \
  confluentinc/confluent-for-kubernetes \
  --namespace confluent --set namespaced=false