#!/usr/bin/env bash


HOST_FILE=${1:-cp-inventory-5.4.yml}

ansible -m ping all -i $HOST_FILE
