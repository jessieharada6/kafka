# after setting up the word-count-app, and created two topics 
# word-count-input
# word-count-output
kafka-topics.sh --bootstrap-server localhost:9092 --list 
# outcome
__consumer_offsets
streams-plaintext-input
streams-wordcount-KSTREAM-AGGREGATE-STATE-STORE-0000000003-changelog
streams-wordcount-KSTREAM-AGGREGATE-STATE-STORE-0000000003-repartition
streams-wordcount-output
word-count-application-Counts-changelog
word-count-application-Counts-repartition
word-count-input
word-count-output

# wordcount internal topics
# application.id is word-count-application - it is the prefix, if change application.id, these internal topics will be recreated
# changelog: perform aggregations, kafka streams will save compacted data in thse topics 
word-count-application-Counts-changelog 
# repartition: transform key of the stream, a repartitioning happens at some processor
word-count-application-Counts-repartition

# to describe
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
        --topic word-count-application-Counts-changelog  \
        --from-beginning \
        --formatter kafka.tools.DefaultMessageFormatter \
        --property print.key=true \
        --property print.value=true \
        # string, string
        --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
        --property value.deserializer=org.apache.kafka.common.serialization.StringDeserializer

