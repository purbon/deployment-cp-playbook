#!/usr/bin/env bash

## Set namespace
kubens confluent-sssl

export MY_HOME=$(pwd)

## Validate

kubectl port-forward controlcenter-0 9021:9021
