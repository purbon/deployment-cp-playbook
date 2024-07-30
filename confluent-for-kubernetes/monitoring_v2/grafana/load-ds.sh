#!/usr/bin/env bash


for i in datasources/*; do \
	curl -X "POST" "http://localhost:8080/api/datasources" \
    -H "Content-Type: application/json" \
     --user admin:prom-operator \
     --data-binary @$i
done
