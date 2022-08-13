package io.demo.kafka;

import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class ProducerWithCallbackKeyless {
    private static final Logger log = LoggerFactory.getLogger(ProducerWithCallbackKeyless.class.getSimpleName());
    public static void main(String[] args) {
        log.info("Hey Kafka Producer with Callback");

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

        for (int i = 0; i < 10; i++) {
            // create a producer message/record
            // KEYLESS
            ProducerRecord<String, String> producerRecord = new ProducerRecord<>("demo_java", "hello world " + i);

            // send data
            producer.send(producerRecord, new Callback() {
                @Override
                public void onCompletion(RecordMetadata metadata, Exception e) {
                    // executes every time a record is successfully sent or an exception is thrown
                    if (e == null) {
                        // record was successfully sent
                        log.info("Received new metadata/ \n" +
                                "Topic: " + metadata.topic() + "\n" +
                                "Partition: " + metadata.partition() + "\n" +
                                "Offset: " + metadata.offset() + "\n" +
                                "Timestamp: " + metadata.timestamp());
                    }
                    else {
                        log.error("Error while producing", e);
                    }
                }
            });

            // by default, partitioner.class = class org.apache.kafka.clients.producer.internals.DefaultPartitioner
            // it is sticky partioner
            // if we want to force round-robin, uncomment code below
            // try {
            //     Thread.sleep(1000);
            // } catch(InterruptedException e) {
            //     e.printStackTrace();
            // }
        }

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
