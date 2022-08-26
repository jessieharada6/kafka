package com.kafka.streams;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.KeyValue;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.kstream.KStream;
import org.apache.kafka.streams.kstream.KTable;
import org.apache.kafka.streams.kstream.Materialized;
import org.apache.kafka.streams.kstream.Produced;

import java.util.Arrays;
import java.util.Properties;

public class FavouriteColourApp {
    public static void main(String[] args) {
        Properties config = new Properties();
        config.put(StreamsConfig.APPLICATION_ID_CONFIG, "favourite-colour-application");
        config.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        config.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        config.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        config.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

        // disable to cache to demonstrate all the steps involved in the transformation
        // only in dev
        config.put(StreamsConfig.CACHE_MAX_BYTES_BUFFERING_CONFIG, "0");

        StreamsBuilder builder = new StreamsBuilder();

        // https://docs.confluent.io/platform/current/streams/developer-guide/dsl-api.html#streams-developer-guide-dsl-transformations-stateless
        // 1. build a clean stream
        KStream<String, String> input = builder.stream("fav-color-input");
        KStream<String, String> userStream = input
                .filter((k, v) -> v.contains(","))
                .selectKey((k, v) -> v.split(",")[0].toLowerCase())
                .mapValues(v -> v.split(",")[1].toLowerCase())
                .filter((k, v) -> Arrays.asList("green", "blue", "red").contains(v));

        userStream.to("user-keys-and-colours");

        // 2. read the topic from stream as a table
        KTable<String, String> userTable = builder.table("user-keys-and-colours");

        // 3. format table
        KTable<String, Long> colorCounts = userTable
                // Groups the records by a new key, which may be of a different key type. When grouping a table, you may also specify a new value and value type.
                .groupBy((k, v) -> new KeyValue<>(v, v))
                .count(Materialized.as("Counts"));

        // 4. present
        colorCounts.toStream().to("fav-color-output", Produced.with(Serdes.String(), Serdes.Long()));
        KafkaStreams streams = new KafkaStreams(builder.build(), config);
        streams.cleanUp(); // only in dev
        streams.start();
        // shutdown hook to close the streams app
        Runtime.getRuntime().addShutdownHook(new Thread(streams::close));
    }
}

// create the 3 topics, for example
    // kafka-topics.sh --bootstrap-server localhost:9092 --topic user-keys-and-colours --partitions 2
// launch a producer for input topic, and start to produce messages
    // kafka-console-producer.sh --bootstrap-server localhost:9092 --topic fav-color-input
    // jessie,blue
    // coco,green
    // jessie:yellow    - wont show
    // jessie,white     - wont show
// to see the intermediate topic, comment out the code below and run the query
    //    // 2. read the topic from stream as a table
    //    KTable<String, String> userTable = builder.table("user-keys-and-colours");
    //
    //        // 3. format table
    //        KTable<String, Long> colorCounts = userTable
    //                .groupBy((k, v) -> new KeyValue<>(v, v))
    //                .count(Materialized.as("Counts"));
    //
    //    // 4. present
    //            colorCounts.toStream().to("fav-color-output", Produced.with(Serdes.String(), Serdes.Long()));
    // kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    //                --topic user-keys-and-colours \
    //                --from-beginning \
    //                --formatter kafka.tools.DefaultMessageFormatter \
    //                --property print.key=true \
    //                --property print.value=true \
    //                --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    //                --property value.deserializer=org.apache.kafka.common.serialization.StringDeserializer
// to see the final topic
    //kafka-console-consumer.sh --bootstrap-server localhost:9092 \
    //        --topic fav-color-output \
    //        --from-beginning \
    //        --formatter kafka.tools.DefaultMessageFormatter \
    //        --property print.key=true \
    //        --property print.value=true \
    //        --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
    //        --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer
