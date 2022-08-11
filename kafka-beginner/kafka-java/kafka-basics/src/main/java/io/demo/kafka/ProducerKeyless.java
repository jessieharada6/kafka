package io.demo.kafka;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class ProducerKeyless {
    private static final Logger log = LoggerFactory.getLogger(ProducerKeyless.class.getSimpleName());
    public static void main(String[] args) {
        log.info("Hey Kafka Producer");

        // create Producer properties
        Properties properties = new Properties();
        // "bootstrap.servers"
        properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "127.0.0.1:9092");
        // "key.serializer" serialise the object to kafka
        properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        // "value.serializer" serialise the object to kafka
        properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        // create Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(properties);

        // create a producer message/record
        // KEYLESS
        ProducerRecord<String, String> producerRecord = new ProducerRecord<>("demo_java", "hello world");

        // send data - asynchronous operation
        // if we just tell the producer to send, it will not wait for it to finish
        // without flushing, we will not send the data
        producer.send(producerRecord);

        // flush the Producer - synchronous, so that we block the operation until all the data is sent
        producer.flush();

        // producer.close() also has producer.flush()
        producer.close();

        // Process finished with exit code 0 - meaning successful

        // TO TEST
        // create a topic
        // kafka-topics.sh --bootstrap-server 127.0.0.1:9092 --create -topic demo_java --partitions 3 --replication-factor 1
        // create a consumer
        // kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic demo_java
    }
}
