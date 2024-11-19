#!/usr/bin/env bash

kubectl create namespace ccloud-ksql
kubens ccloud-ksql

helm upgrade --install confluent-operator \
  confluentinc/confluent-for-kubernetes \
  --namespace ccloud-ksql