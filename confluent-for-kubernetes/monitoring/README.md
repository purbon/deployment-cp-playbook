# Monitoring example



## Deploy Confluent for Kubernetes


kubectl create namespace confluent


helm upgrade --install operator confluentinc/confluent-for-kubernetes  --namespace confluent


kubectl apply -f confluent-platform.yaml


```bash
$ kubectl get pods                                                                                                       2.7.0
NAME                                  READY   STATUS    RESTARTS   AGE
confluent-operator-6f57fd6d97-knk7l   1/1     Running   0          7m59s
connect-0                             1/1     Running   0          5m17s
connect-1                             1/1     Running   0          5m17s
controlcenter-0                       1/1     Running   0          2m49s
kafka-0                               1/1     Running   0          3m50s
kafka-1                               1/1     Running   0          3m50s
kafka-2                               1/1     Running   0          3m50s
ksqldb-0                              1/1     Running   0          2m50s
schemaregistry-0                      1/1     Running   0          2m49s
schemaregistry-1                      1/1     Running   0          2m49s
zookeeper-0                           1/1     Running   0          5m17s
zookeeper-1                           1/1     Running   0          5m17s
zookeeper-2                           1/1     Running   0          5m17s
```


## Deploy Prometheus and Grafana

status
kubectl create namespace monitorings

helm upgrade  --install confluentmon  prometheus-community/kube-prometheus-stack \
 --set alertmanager.persistentVolume.enabled=true \
 --set server.persistentVolume.enabled=true \
 --namespace monitoring

```bash
helm upgrade  --install confluentmon  prometheus-community/kube-prometheus-stack \
 --set alertmanager.persistentVolume.enabled=true \
 --set server.persistentVolume.enabled=true \
 --set grafana.sidecar.datasources.uid=promsys \
 --namespace monitoring

 ```

 ```bash
 helm upgrade --install azuredeploy stable/prometheus \
  --set alertmanager.persistentVolume.enabled=true \
  --set server.persistentVolume.enabled=true \
  --set-file extraScrapeConfigs=./prometheus/extraScrapeConfigs.yaml \
  --namespace monitoring
```


kubectl get secret --namespace monitoring confluentmon-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

prom-operator
