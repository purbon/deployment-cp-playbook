
curl -i -k -u "testadmin:testadmin" -X PUT https://localhost:8083/connectors/datagen_local_01/config \
     -H "Content-Type: application/json" \
     -d '{
            "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
            "kafka.topic": "inventory",
            "quickstart": "inventory",
            "key.converter": "org.apache.kafka.connect.storage.StringConverter",
            "value.converter": "org.apache.kafka.connect.json.JsonConverter",
            "value.converter.schemas.enable": "false",
            "max.interval": 1000,
            "iterations": 10000000,
            "tasks.max": "1"
        }'
