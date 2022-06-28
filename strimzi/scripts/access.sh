#!/usr/bin/env bash

###
# How to access a kafka cluster within the cluster (mTLS authentication)
###

kubectl run --restart=Never --image=quay.io/strimzi/kafka:0.29.0-kafka-3.2.0 \
            kafka-admin -- /bin/sh -c "sleep 3600"


kubectl get secret cflt-cluster-ca-cert -o jsonpath='{.data.ca\.p12}' | base64 -d > ca.p12
kubectl get secret cflt-cluster-ca-cert -o jsonpath='{.data.ca\.password}' | base64 -d > ca.password
kubectl cp ca.p12 kafka-admin:/tmp

kubectl get secret cp-super -o jsonpath='{.data.user\.p12}' | base64 -d > user.p12
kubectl get secret cp-super -o jsonpath='{.data.user\.password}' | base64 -d > user.password
kubectl cp user.p12 kafka-admin:/tmp


kubectl get secret cflt-kafka-brokers -o jsonpath='{.data.cflt-kafka-0\.p12}' | base64 -d > broker.p12
kubectl get secret cflt-kafka-brokers -o jsonpath='{.data.cflt-kafka-0\.password}' | base64 -d > broker.password
kubectl cp broker.p12 kafka-admin:/tmp

USAGE=$(cat <<-END
--- create a file with this content muster (config.properties) ---
bootstrap.servers=cflt-kafka-bootstrap:9093
security.protocol=SSL
ssl.truststore.location=/tmp/ca.p12
ssl.truststore.password=<ca.password>
ssl.keystore.location=/tmp/user.p12
ssl.keystore.password=<user.password>
----

Copy the file to the pod

$> kubectl cp config.properties kafka-admin:/tmp/config.properties


--- example command you can run now ---

./bin/kafka-topics.sh --bootstrap-server cflt-kafka-bootstrap:9093 \
                      --command-config /tmp/config.properties \
                      --list

./bin/kafka-acls.sh --bootstrap-server cflt-kafka-bootstrap:9093 \
                    --command-config /tmp/config.properties \
                    --list
END
)

echo $USAGE
echo
echo "thanks!"
