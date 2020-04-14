
curl -X POST -H "Content-Type: application/json" --data '{"name": "local-file-sink", "config": {"connector.class":"FileStreamSinkConnector", "tasks.max":"1", "file":"test.sink.txt", "topics":"connect-test" }}' http://localhost:8083/connectors
# Or, to use a file containing the JSON-formatted configuration


curl -X DELETE http://ec2-54-171-57-190.eu-west-1.compute.amazonaws.com:8083/connectors/jdbc-trigger-offload

curl -X DELETE http://ec2-54-171-57-190.eu-west-1.compute.amazonaws.com:8083/connectors/jdbc-trigger-offload-schema-magic

curl -X POST -H "Content-Type: application/json" --data @json-sink-with-schema.json http://ip-172-31-28-57.eu-west-1.compute.internal:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @json-sink-without-schema.json http://ip-172-31-28-57.eu-west-1.compute.internal:8083/connectors


curl -X POST -H "Content-Type: application/json" --data @config.json http://ip-172-31-28-57.eu-west-1.compute.internal:8083/connectors
