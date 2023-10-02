#!/usr/bin/bash env

kubectl apply -f resources/kafka.yaml  
kubectl apply -f resources/krest.yaml  
kubectl apply -f resources/connector.yaml
kubectl apply -f resources/schema-registry.yaml  
kubectl apply -f resources/controlcenter.yaml


## custom permissions

kubectl apply -f resources/testadmin-rolebindings.yaml


## topics

kubectl apply -f resources/topic.yaml