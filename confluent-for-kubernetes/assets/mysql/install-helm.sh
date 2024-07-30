#!/usr/bin/env bash

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install -f my-values.yaml my-mysql bitnami/mysql --version 11.1.16