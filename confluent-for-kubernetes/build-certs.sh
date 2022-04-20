#!/usr/bin/env bash


export TUTORIAL_HOME=$(pwd)
mkdir $TUTORIAL_HOME/assets/certs/generated && cfssl gencert -initca $TUTORIAL_HOME/assets/certs/ca-csr.json | cfssljson -bare $TUTORIAL_HOME/assets/certs/generated/ca -
openssl x509 -in $TUTORIAL_HOME/assets/certs/generated/ca.pem -text -noout

cfssl gencert -ca=$TUTORIAL_HOME/assets/certs/generated/ca.pem \
-ca-key=$TUTORIAL_HOME/assets/certs/generated/ca-key.pem \
-config=$TUTORIAL_HOME/assets/certs/ca-config.json \
-profile=server $TUTORIAL_HOME/assets/certs/server-domain.json | cfssljson -bare $TUTORIAL_HOME/assets/certs/generated/server

# Validate server certificate and SANs
openssl x509 -in $TUTORIAL_HOME/assets/certs/generated/server.pem -text -noout
