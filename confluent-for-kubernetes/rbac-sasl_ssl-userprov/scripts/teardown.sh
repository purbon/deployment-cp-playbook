## Set namespace
kubens confluent-sssl

kubectl delete confluentrolebinding --all

#kubectl delete -f ./confluent-platform-production-mtls.yaml

export MY_HOME=$(pwd)
kubectl delete -f $MY_HOME/resources/zookeeper.yaml
kubectl delete -f $MY_HOME/resources/kafka.yaml
kubectl delete -f $MY_HOME/resources/controlcenter.yaml
kubectl delete -f $MY_HOME/resources/connect.yaml
kubectl delete -f $MY_HOME/resources/ksqldb.yaml
kubectl delete -f $MY_HOME/resources/schemaregistry.yaml

kubectl delete secret rest-credential ksqldb-mds-client sr-mds-client connect-mds-client krp-mds-client c3-mds-client mds-client ca-pair-sslcerts

kubectl delete secret tls-kafkarestproxy tls-connect tls-controlcenter tls-group1 tls-kafka tls-kafka-external tls-kafka-internal tls-ksqldb tls-schemaregistry tls-zookeeper

kubectl delete secret mds-token

kubectl delete secret credential

helm delete test-ldap

helm delete operator


# connect.confluent-sssl.svc.cluster.local
