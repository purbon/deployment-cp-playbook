#!/usr/bin/env bash


## Operator
kubectl create namespace confluent
helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace confluent

## LDAP
helm upgrade --install -f ../assets/openldap/ldaps-rbac.yaml test-ldap ../assets/openldap --namespace confluent

# kubectl --namespace confluent exec -it ldap-0 -- bash
# ldapsearch -LLL -x -H ldap://ldap.confluent.svc.cluster.local:389 -b 'dc=test,dc=com' -D "cn=mds,dc=test,dc=com" -w 'Developer!'


## Credentials and secrets

### TLS
export MY_HOME=$(pwd)
kubectl create secret generic tls-group1 \
  --from-file=fullchain.pem=$MY_HOME/../assets/certs/generated/server.pem \
  --from-file=cacerts.pem=$MY_HOME/../assets/certs/generated/ca.pem \
  --from-file=privkey.pem=$MY_HOME/../assets/certs/generated/server-key.pem \
  --namespace confluent


### Authentication

kubectl create secret generic credential \
  --from-file=plain-users.json=$MY_HOME/creds-kafka-sasl-users.json \
  --from-file=digest-users.json=$MY_HOME/creds-zookeeper-sasl-digest-users.json \
  --from-file=digest.txt=$MY_HOME/creds-kafka-zookeeper-credentials.txt \
  --from-file=plain.txt=$MY_HOME/creds-client-kafka-sasl-user.txt \
  --from-file=basic.txt=$MY_HOME/creds-control-center-users.txt \
  --from-file=ldap.txt=$MY_HOME/ldap.txt \
  --namespace confluent


### RBAC princials credentials

kubectl create secret generic mds-token \
  --from-file=mdsPublicKey.pem=$MY_HOME/../assets/certs/mds-publickey.txt \
  --from-file=mdsTokenKeyPair.pem=$MY_HOME/../assets/certs/mds-tokenkeypair.txt \
  --namespace confluent

  # Kafka RBAC credential
  kubectl create secret generic mds-client \
    --from-file=bearer.txt=$MY_HOME/bearer.txt \
    --namespace confluent
  # Control Center RBAC credential
  kubectl create secret generic c3-mds-client \
    --from-file=bearer.txt=$MY_HOME/c3-mds-client.txt \
    --namespace confluent
  # Connect RBAC credential
  kubectl create secret generic connect-mds-client \
    --from-file=bearer.txt=$MY_HOME/connect-mds-client.txt \
    --namespace confluent
  # Schema Registry RBAC credential
  kubectl create secret generic sr-mds-client \
    --from-file=bearer.txt=$MY_HOME/sr-mds-client.txt \
    --namespace confluent
  # ksqlDB RBAC credential
  kubectl create secret generic ksqldb-mds-client \
    --from-file=bearer.txt=$MY_HOME/ksqldb-mds-client.txt \
    --namespace confluent
  # Kafka Rest Proxy RBAC credential
  kubectl create secret generic krp-mds-client \
    --from-file=bearer.txt=$MY_HOME/krp-mds-client.txt \
    --namespace confluent
  # Kafka REST credential
  kubectl create secret generic rest-credential \
    --from-file=bearer.txt=$MY_HOME/bearer.txt \
    --from-file=basic.txt=$MY_HOME/bearer.txt \
    --namespace confluent


## Deploy Confluent Platform

kubectl apply -f $MY_HOME/confluent-platform-production.yaml --namespace confluent

### Troubleshooting, get events

# kubectl get events --namespace confluent
# Warning  KeyInSecretRefIssue  kafka/kafka  required key [ldap.txt] missing in secretRef [credential] for auth type [ldap_simple]


## See internal role bindings
kubectl get confluentrolebinding --namespace confluent

## Create roledingins for control center admin

kubectl apply -f $MY_HOME/controlcenter-testadmin-rolebindings.yaml --namespace confluent


## Validate

kubectl port-forward controlcenter-0 9021:9021 --namespace confluent


## Update users

kubectl --namespace confluent create secret generic credential \
    --from-file=plain-users.json=$MY_HOME/creds-kafka-sasl-users.json \
    --from-file=digest-users.json=$MY_HOME/creds-zookeeper-sasl-digest-users.json \
    --from-file=digest.txt=$MY_HOME/creds-kafka-zookeeper-credentials.txt \
    --from-file=plain.txt=$MY_HOME/creds-client-kafka-sasl-user.txt \
    --from-file=basic.txt=$MY_HOME/creds-control-center-users.txt \
    --from-file=ldap.txt=$MY_HOME/ldap.txt \
    --save-config --dry-run=client -oyaml | kubectl apply -f -


###
## Cluster link
###

kubectl apply -f $MY_HOME/clusterlink-rbac.yaml --namespace confluent


###
# Setup password encoder
###

kubectl create secret generic encodersecret \
   --from-file=password-encoder.txt=$MY_HOME/pencoder/password-encoder.txt
