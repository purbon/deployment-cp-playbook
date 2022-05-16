#!/usr/bin/env bash

## Set namespace
kubens confluent-sssl

export MY_HOME=$(pwd)

###
## Cluster link
###

kubectl apply -f $MY_HOME/clusterlink-rbac.yaml --namespace confluent


###
# Setup password encoder
###

kubectl create secret generic encodersecret \
   --from-file=password-encoder.txt=$MY_HOME/pencoder/password-encoder.txt
