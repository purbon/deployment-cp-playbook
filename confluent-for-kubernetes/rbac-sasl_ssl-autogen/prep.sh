#!/usr/bin/env bash

mkdir -p cfk
helm pull confluentinc/confluent-for-kubernetes \
  --untar --untardir=cfk
kubectl apply -f cfk/confluent-for-kubernetes/crds

kubectl create namespace kafka-sasl-ssl
kubectl apply -f cfk-permissions.yaml


###
helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace kafka-sasl-ssl
kubens  kafka-sasl-ssl

helm upgrade --install -f ../assets/openldap/ldaps-rbac.yaml test-ldap ../assets/openldap 
kubectl  exec -it ldap-0 -- bash

ldapsearch -LLL -x -H ldap://ldap.kafka-sasl-ssl.svc.cluster.local:389 -b 'dc=test,dc=com' -D "cn=mds,dc=test,dc=com" -w 'Developer!'