#!/usr/bin/env bash

kubectl delete confluentrolebinding --all --namespace confluent

kubectl delete -f ./confluent-platform.yaml --namespace confluent


export MY_NAMESPACE="cfksaslplain"

kubectl get confluent --namespace $MY_NAMESPACE

kubectl delete -f ./confluent-platform.yaml --namespace $MY_NAMESPACE

helm delete operator --namespace $MY_NAMESPACE
