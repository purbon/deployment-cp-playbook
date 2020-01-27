#!/usr/bin/env bash

ansible -m ping -i ldap-inventory.yml all
