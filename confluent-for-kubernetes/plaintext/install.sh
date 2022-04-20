#!/usr/bin/env bash

## default environment confluent-plain

kubectl create namespace cfkplain
kubens cfkplain

## Operator
helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace cfkplain


## Confluent Platform as Plaintext
export MY_HOME=$(pwd)
kubectl apply -f $MY_HOME/confluent-platform-plaintext.yaml --namespace cfkplain


## Verify
#  kubectl port-forward controlcenter-0 9021:9021 --namespace confluent

## Advertise listeners
## advertised.listeners=EXTERNAL://kafka-0.kafka.confluent.svc.cluster.local:9092,
##                      INTERNAL://kafka-0.kafka.confluent.svc.cluster.local:9071,
##                      REPLICATION://kafka-0.kafka.confluent.svc.cluster.local:9072
## listener.security.protocol.map=EXTERNAL:PLAINTEXT,INTERNAL:PLAINTEXT,REPLICATION:PLAINTEXT
## listeners=EXTERNAL://:9092,INTERNAL://:9071,REPLICATION://:9072


###
## RBAC with CFK can be enabled for new installations. You can not upgrade an existing cluster and enable it with RBAC.
###


###
# https://docs.confluent.io/platform/current/security/rbac/enable-rbac-running-cluster.html
###
