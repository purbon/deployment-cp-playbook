#!/usr/bin/env bash

# Create the monitoring stack using the config in the manifests directory

kubectl apply --server-side -f manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f manifests/

## tear down
## kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup


## Operator

# If required
## helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
## helm repo update


kubectl create namespace monitoring  

helm upgrade  --install confluentmon  prometheus-community/kube-prometheus-stack \
 --set alertmanager.persistentVolume.enabled=true \
 --set server.persistentVolume.enabled=true \
 --set grafana.sidecar.datasources.uid=promsys \
 --namespace monitoring


helm upgrade  --install confluentmon  prometheus-community/kube-prometheus-stack \
 --set alertmanager.persistentVolume.enabled=true \
 --set server.persistentVolume.enabled=true \
 --set grafana.sidecar.datasources.uid=promsys \
 -f values.yaml \
 --namespace monitoring


kubectl apply -f prometheus/rbac.yaml 

kubectl apply -f prometheus/service-monitor.yaml  

kubectl apply -f prometheus/prometheus.yaml      