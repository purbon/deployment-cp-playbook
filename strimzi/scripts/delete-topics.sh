#!/usr/bin/env bash

###
# How to delete a topic using a support temporary pod
###

kubectl run kafka-admin -ti --image=quay.io/strimzi/kafka:0.29.0-kafka-3.2.0 \
        --rm=true --restart=Never\
        -- ./bin/kafka-topics.sh --bootstrap-server localhost:9092 \
        --topic __strimzi-topic-operator-kstreams-topic-store-changelog \
        --delete && ./bin/kafka-topics.sh --bootstrap-server localhost:9092 \
        --topic __strimzi_store_topic --delete
