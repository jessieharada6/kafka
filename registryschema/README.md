## read from topic
confluent kafka topic consume --from-beginning [topic_name]

### however, the above command will result in unreadable data if we have defined/serialised the schema as avro when producing to kafka
### to deserialise it when consuming
confluent kafka topic consume --value-format avro --sr-api-key [api-key-under-topic-under-schema-registry] --sr-api-secret [api-secret-under-topic-under-schema-registry] [topic_name]