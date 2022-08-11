package io.demo.kafka;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Array;
import java.time.Duration;
import java.util.Arrays;
import java.util.Collections;
import java.util.Properties;

public class Consumer {
    private static final Logger log = LoggerFactory.getLogger(ProducerKeyless.class.getSimpleName());
    public static void main(String[] args) {
        log.info("Hey Kafka Consumer");

        String bootstrapServer = "127.0.0.1:9092";
        String groupId = "first-application";
        String topic = "demo_java";

        // Consumer Properties
        Properties properties = new Properties();
        // "bootstrap.servers"
        properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
        properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        // none: if no offsets found, dont start
        // earliest: read from earliest, --from-beginning
        // latest: read the latest
        properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

        // Create consumer
        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(properties);

        // Subscribe consumer to the topic(s)
        // to a single topic
        consumer.subscribe(Collections.singletonList(topic));
        // to multiple topics
        //consumer.subscribe(Arrays.asList(topic));

        // poll kafka,
        while(true) {
            log.info("Polling");

            // poll if there are records/messages
            // if no records, wait for 100ms, and go to the next line
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(100));

            for(ConsumerRecord<String, String> record : records) {
                log.info("Key: " + record.key() + " , Value: " + record.value());
                log.info("Partition: " + record.partition() + " , Offset: " + record.offset());
            }
        }
    }
}
