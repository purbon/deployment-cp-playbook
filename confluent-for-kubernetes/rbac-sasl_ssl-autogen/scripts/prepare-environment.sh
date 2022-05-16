#!/usr/bin/env bash


## Operator
kubectl create namespace kafka-sasl-ssl
helm upgrade --install operator confluentinc/confluent-for-kubernetes \
             --set rbac=false \
             --set namespaced=true \
             --namespace kafka-sasl-ssl

## LDAP
helm upgrade --install -f ../assets/openldap/ldaps-rbac.yaml test-ldap ../assets/openldap --namespace kafka-sasl-ssl

# kubectl exec -it ldap-0 -- bash
# ldapsearch -LLL -x -H ldap://ldap.confluent-sssl.svc.cluster.local:389 -b 'dc=test,dc=com' -D "cn=mds,dc=test,dc=com" -w 'Developer!'
##
# ldapsearch -LLL -x -H  ldaps://ldap-0.ldap.confluent.svc.cluster.local:63 -b 'dc=test,dc=com' -D "cn=mds,dc=test,dc=com" -w 'Developer!'
##
## LDAPTLS_REQCERT=ALLOW (also LDAPTLD_CERT=/path/to/cert
