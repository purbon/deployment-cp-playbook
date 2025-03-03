helm upgrade --install operator confluentinc/confluent-for-kubernetes --set kRaftEnabled=true -n confluent

helm upgrade --install -f ../assets/openldap/ldaps-rbac.yaml test-ldap ../assets/openldap --namespace confluent

# Resources

kubens confluent

kubectl create secret tls ca-pair-sslcerts \
  --cert=./ca.pem \
  --key=./ca-key.pem

kubectl create secret generic tls-group1 \
    --from-file=fullchain.pem=../assets/certs/generated/server.pem \
    --from-file=cacerts.pem=../assets/certs/generated/cacerts.pem \
    --from-file=privkey.pem=../assets/certs/generated/server-key.pem


kubectl create secret generic credential2 \
    --from-file=plain-users.json=./secrets/creds-kafka-sasl-users.json \
    --from-file=plain.txt=./secrets/creds-client-kafka-sasl-user.txt \
    --from-file=ldap.txt=./secrets/ldap.txt \
    --from-file=oidcClientSecret.txt=./secrets/oidcClientSecret.txt


## RBAC 

kubectl create secret generic mds-token \
  --from-file=mdsPublicKey.pem=../assets/certs/mds-publickey.txt \
  --from-file=mdsTokenKeyPair.pem=../assets/certs/mds-tokenkeypair.txt \
  --namespace confluent

# Kafka RBAC credential
kubectl create secret generic mds-client \
    --from-file=bearer.txt=./secrets/bearer.txt \
    --namespace confluent

kubectl create secret generic c3-mds-client \
    --from-file=bearer.txt=./secrets/c3-mds-client.txt \
    --namespace confluent

# Kafka REST credential
kubectl create secret generic rest-credential \
    --from-file=bearer.txt=./secrets/bearer.txt \
    --from-file=basic.txt=./secrets/bearer.txt \
    --namespace confluent


kubectl create secret generic mycustomtruststore --from-file=truststore.jks=./entraID/idpcerts.jks
