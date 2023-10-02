#!/usr/bin/env bash

helm upgrade --install -f ../assets/openldap/ldaps-rbac.yaml test-ldap ../assets/openldap --namespace confluent
