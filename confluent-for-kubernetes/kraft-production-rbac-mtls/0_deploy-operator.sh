#!/usr/bin/env bash

kubectl create namespace confluent
kubens confluent

helm upgrade --install confluent-operator \
  confluentinc/confluent-for-kubernetes \
  --set kRaftEnabled=true \
  --set namespaced=false \
  --namespace confluent