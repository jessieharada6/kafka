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
        // auto.offset.reset
        // "defines how a consumer should behave when consuming from a topic partition when there is no initial offset"
        // This is most typically of interest when a new consumer group has been defined and is listening to a topic for the first time. This configuration will tell the consumers in the group whether to read from the beginning or end of the partition.
        // https://medium.com/lydtech-consulting/kafka-consumer-auto-offset-reset-d3962bad2665#:~:text=The%20auto%20offset%20reset%20consumer%20configuration%20defines%20how%20a%20consumer,topic%20for%20the%20first%20time.
        // none: if no offsets found in the consumer group, throw exception
        // earliest: read from earliest offset, --from-beginning, take into consideration for the auto commited offset, if auto commited, start from the commited offset onwards
        // latest: read the latest, new messages write to the topic, alr read messages won't come in
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
