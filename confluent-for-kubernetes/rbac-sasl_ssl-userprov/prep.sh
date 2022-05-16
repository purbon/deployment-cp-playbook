#!/usr/bin/env bash

mkdir -p cfk
helm pull confluentinc/confluent-for-kubernetes \
  --untar --untardir=cfk
kubectl apply -f cfk/confluent-for-kubernetes/crds

kubectl create namespace kafka-sasl-ssl-user
kubectl apply -f cfk-permissions.yaml
