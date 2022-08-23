package com.kafka.streams;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.kstream.KStream;
import org.apache.kafka.streams.kstream.KTable;
import org.apache.kafka.streams.kstream.Materialized;
import org.apache.kafka.streams.kstream.Produced;

import java.util.Arrays;
import java.util.Properties;

public class WordCountApp {
    public static void main(String[] args) {
        Properties config = new Properties();
        config.put(StreamsConfig.APPLICATION_ID_CONFIG, "word-count-application");
        config.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        config.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        config.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        config.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

        StreamsBuilder builder = new StreamsBuilder();

        // 1. INPUT: get a stream from kafka topic: <null: "Kafka Kafka Streams">
        // create the topic using
        // kafka-topics.sh --bootstrap-server localhost:9092 --topic word-count-input --partitions 2 --create
        KStream<String, String> wordCountInput = builder.stream("word-count-input");

        KTable<String, Long> wordCounts = wordCountInput
                // 2. map values to lower case: <null: "kafka kafka streams">
                .mapValues(v -> v.toLowerCase())
                // 3. flat map values, split values by space with key: <null: "kafka"><null: "kafka"><null: "streams">
                .flatMapValues(v -> Arrays.asList(v.split(" ")))
                // 4. select key to apply for a key: <"kafka": "kafka"><"kafka": "kafka"><"streams": "streams">
                .selectKey((k, v) -> v)
                // 5. group by key before aggregation: (<"kafka": "kafka">,<"kafka": "kafka">),(<"streams": "streams">)
                .groupByKey()
                // 6. count occurences
                .count(Materialized.as("Counts"));

        // 7. OUTPUT: output (the ktable) the results back to kafka in order
        // create the topic using
        // kafka-topics.sh --bootstrap-server localhost:9092 --topic word-count-output --partitions 2 --create
        // "word-count-output" - output topic
        // Serdes.String(), Serdes.Long() - key, value - match the data type of ktable
        wordCounts.toStream().to("word-count-output", Produced.with(Serdes.String(), Serdes.Long()));

        KafkaStreams streams = new KafkaStreams(builder.build(), config);
        streams.start();
        // print the topology
        System.out.println(streams.toString());

        // shutdown hook to close the streams app
        Runtime.getRuntime().addShutdownHook(new Thread(streams::close));
    }
}


// launch a producer to send to the input topic
//        kafka-console-producer.sh --bootstrap-server localhost:9092 --topic word-count-input
// launch a consumer to read the output topic
//        kafka-console-consumer.sh --bootstrap-server localhost:9092 \
//        --topic word-count-output \
//        --from-beginning \
//        --formatter kafka.tools.DefaultMessageFormatter \
//        --property print.key=true \
//        --property print.value=true \
//        --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \
//        --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer


