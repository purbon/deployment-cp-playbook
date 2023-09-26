#!/usr/bin/env bash

helm repo add confluentinc https://packages.confluent.io/helm
kubectl create namespace confluent


kubens confluent

helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace confluent

kubectl get pods

## deploy secrets

kubectl create secret generic basicsecret --from-file=basic.txt=./resources/basic.txt 