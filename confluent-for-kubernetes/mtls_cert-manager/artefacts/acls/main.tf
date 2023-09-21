terraform {
  required_providers {
    kafka = {
      source = "Mongey/kafka"
    }
  }
}


provider "kafka" {
  bootstrap_servers = ["localhost:9092"]
  ca_cert      = "ca.pem"
  client_cert  = "cert.pem"
  client_key   = "key.pem"
  skip_tls_verify   = true
}

resource "kafka_acl" "test" {
  resource_name       = "syslog"
  resource_type       = "Topic"
  acl_principal       = "User:Alice"
  acl_host            = "*"
  acl_operation       = "Write"
  acl_permission_type = "Deny"
}

resource "kafka_acl" "topic-a" {
  resource_name       = "topic-a"
  resource_type       = "Topic"
  acl_principal       = "User:Bob"
  acl_host            = "*"
  acl_operation       = "Read"
  acl_permission_type = "Deny"
}