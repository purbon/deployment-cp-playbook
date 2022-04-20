#!/usr/bin/env bash

kubectl delete confluentrolebinding --all --namespace confluent

kubectl delete -f ./confluent-platform-production.yaml --namespace confluent

kubectl delete secret rest-credential ksqldb-mds-client sr-mds-client connect-mds-client krp-mds-client c3-mds-client mds-client ca-pair-sslcerts --namespace confluent

kubectl delete secret mds-token --namespace confluent

kubectl delete secret credential --namespace confluent

kubectl delete secret tls-group1 --namespace confluent

helm delete test-ldap --namespace confluent

helm delete operator --namespace confluent
