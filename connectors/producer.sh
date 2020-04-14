kafka-console-producer \
  --broker-list localhost:9092 \
  --topic triggers \
  --property "parse.key=true" \
  --property "key.separator=:"
key1:{"schema":{"type":"struct","fields":[{"type":"double","optional":false,"field":"revenue"},{"type":"double","optional":false,"field":"expenses"},{"type":"double","optional":false,"field":"profit"}],"optional":false,"name":"total data"},"payload":{"revenue":12345.0, "expenses":214365.0,"profit":1.0}}
key2:{"schema":{"type":"struct","fields":[{"type":"double","optional":false,"field":"revenue"},{"type":"double","optional":false,"field":"expenses"},{"type":"double","optional":false,"field":"profit"}],"optional":false,"name":"total data"},"payload":{"revenue":67890.0, "expenses":563412.0,"profit":2.0}}
key3:{"schema":{"type":"struct","fields":[{"type":"double","optional":false,"field":"revenue"},{"type":"double","optional":false,"field":"expenses"},{"type":"double","optional":false,"field":"profit"}],"optional":false,"name":"total data"},"payload":{"revenue":12345.0, "expenses":987654.0,"profit":3å.0}}


kafka-console-producer \
  --broker-list localhost:9092 \
  --topic triggers \
  --property "parse.key=true" \
  --property "key.separator=:"
key1:{"schema":{"type":"struct","fields":[{"type":"double","optional":false,"field":"revenue"},{"type":"double","optional":false,"field":"expenses"},{"type":"double","optional":false,"field":"profit"}],"optional":false,"name":"total data"},"payload":{"revenue":12345.0, "expenses":214365.0,"profit":1.0}}
key2:{"schema":{"type":"struct","fields":[{"type":"double","optional":false,"field":"revenue"},{"type":"double","optional":false,"field":"expenses"},{"type":"double","optional":false,"field":"profit"}],"optional":false,"name":"total data"},"payload":{"revenue":67890.0, "expenses":563412.0,"profit":2.0}}
key3:{"schema":{"type":"struct","fields":[{"type":"double","optional":false,"field":"revenue"},{"type":"double","optional":false,"field":"expenses"},{"type":"double","optional":false,"field":"profit"}],"optional":false,"name":"total data"},"payload":{"revenue":12345.0, "expenses":987654.0,"profit":3å.0}}



GRANT ALL ON *.* to root@'%' IDENTIFIED BY 'put-your-password';


kafka-console-producer \
  --broker-list localhost:9092 \
  --topic triggers

{ "schema": {  "type": "struct", "fields": [ { "type": "int64", "optional": false, "field": "registertime" }, {  "type": "string", "optional": false, "field": "userid" }, { "type": "string", "optional": false, "field": "regionid" }, { "type": "string", "optional": false, "field": "gender" } ], "optional": false, "name": "ksql.users" },  "payload": {  "registertime": 1493819497170, "userid": "User_1", "regionid": "Region_5", "gender": "MALE" } }

{ "schema": {  "type": "struct", "fields": [ { "type": "int64", "optional": false, "field": "registertime" }, {  "type": "string", "optional": false, "field": "userid" }, { "type": "string", "optional": false, "field": "regionid" }, { "type": "string", "optional": false, "field": "gender" } ], "optional": false, "name": "ksql.users" },  "payload": {  "registertime": 1493819497170, "userid": "User_2", "regionid": "Berlin", "gender": "MALE" } }



kafka-console-producer \
  --broker-list localhost:9092 \
  --topic events

{  "registertime": 1493819497170, "userid": "User_2", "regionid": "Berlin", "gender": "MALE" }
{  "registertime": 1493819497170, "userid": "User_1", "regionid": "Barcelona", "gender": "FEMALE" }

{  "registertime": "1493819497170", "userid": "User_1", "regionid": "Barcelona", "gender": "FEMALE" }
{  "registertime": "1493819497170", "userid": "User_2", "regionid": "Berlin", "gender": "FEMALE" }
{  "registertime": "1493819497170", "userid": "User_3", "regionid": "Madrid", "gender": "FEMALE" }

{  "registertime": "1493819497170", "userid": "User_1", "regionid": "Barcelona", "gender": "FEMALE", "country": "Spain" }
{  "registertime": "1493819497170", "userid": "User_2", "regionid": "Berlin", "gender": "FEMALE", "country": "Germany" }
