#!/usr/bin/env bash

## default environment confluent-plain

kubectl create namespace cfksaslplain
kubens cfksaslplain

## Operator
helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace cfksaslplain

## Sasl credentials
export MY_HOME=$(pwd)

kubectl create secret generic credential \
  --from-file=plain-users.json=$MY_HOME/creds-plain-users.json \
  --from-file=plain.txt=$MY_HOME/creds-plain.txt \
  --namespace cfksaslplain

kubectl create secret generic in-auth-kafka-external \
    --from-file=plain-users.json=$MY_HOME/creds-plain-users.json \
    --from-file=plain.txt=$MY_HOME/creds-plain.txt \
    --namespace cfksaslplain


kubectl create secret generic plain-client \
    --from-file=plain.txt=$MY_HOME/creds-plain.txt \
    --namespace cfksaslplain

kubectl create secret generic basic-client \
    --from-file=basic.txt=$MY_HOME/basic-auth.txt \
    --namespace cfksaslplain


###
# For Cluster linking
##

kubectl create secret generic basic-client \
  --from-file=basic.txt=$MY_HOME/basic-auth.txt \
  --namespace confluent

  kubectl create secret generic plain-client \
      --from-file=plain.txt=$MY_HOME/creds-plain.txt \
      --namespace confluent

###

## Confluent Platform as Plaintext
kubectl apply -f $MY_HOME/confluent-platform.yaml --namespace cfksaslplain
kubectl apply -f $MY_HOME/kafkaRestClass.yaml --namespace cfksaslplain
