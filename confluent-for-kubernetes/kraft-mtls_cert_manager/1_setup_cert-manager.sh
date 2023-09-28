#!/usr/bin/env bash

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml

kubectl create namespace confluent-certs
kubectl  -k cert-manager/self-signed apply  