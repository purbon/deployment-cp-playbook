#!/usr/bin/env bash

kubectl delete confluentrolebinding --all --namespace confluent

kubectl delete -f ./confluent-platform-plaintext.yaml --namespace confluent


export MY_NAMESPACE="cfkplain"

kubectl get confluent --namespace $MY_NAMESPACE

kubectl delete -f ./confluent-platform-plaintext.yaml --namespace $MY_NAMESPACE

helm delete operator --namespace $MY_NAMESPACE
