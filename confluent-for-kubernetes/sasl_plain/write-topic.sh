#!/usr/bin/env bash


kafka-topics --bootstrap-server localhost:9204 --create --topic demo --partitions 1 --replication-factor 3

 kafka-console-producer --bootstrap-server localhost:9204 --topic demo

 kafka-console-consumer --bootstrap-server localhost:9204 --topic demo --from-beginning


kafka-console-consumer --bootstrap-server kafka-0.kafka.confluent.svc.cluster.local:9073 \
                       --topic demo --from-beginning \
                       --consumer.config /tmp/client.props

kubectl cp client.props kafka-0:/tmp/client.props


ssl.endpoint.identification.algorithm=

security.protocol=SASL_SSL
ssl.key.password=mystorepassword
ssl.keystore.location=/mnt/sslcerts/keystore.p12
ssl.keystore.password=mystorepassword
ssl.truststore.location=/mnt/sslcerts/truststore.p12
ssl.truststore.password=mystorepassword
sasl.mechanism=OAUTHBEARER
sasl.login.callback.handler.class=io.confluent.kafka.clients.plugins.auth.token.TokenUserLoginCallbackHandler
sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required username="c3" password="c3-secret"  metadataServerUrls="https://kafka-0.kafka.confluent.svc.cluster.local:8090";
