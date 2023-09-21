#!/usr/bin/env bash

kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

kubectl apply -f https://raw.githubusercontent.com/weaveworks/tf-controller/main/docs/release.yaml

