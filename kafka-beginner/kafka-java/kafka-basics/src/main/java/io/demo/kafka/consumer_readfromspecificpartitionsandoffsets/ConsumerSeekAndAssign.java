package io.demo.kafka.consumer_readfromspecificpartitionsandoffsets;

import java.time.Duration;
import java.util.Arrays;
import java.util.Properties;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

// https://www.conduktor.io/kafka/java-consumer-seek-and-assign
// To use these API, make the following changes:
//Remove the group.id from the consumer properties (we don't use consumer groups anymore)
//Remove the subscription to the topic
//Use consumer assign() and seek() APIs
public class ConsumerSeekAndAssign {
    public static void main(String[] args) {

        Logger log = LoggerFactory.getLogger(ConsumerSeekAndAssign.class.getName());

        String bootstrapServers = "127.0.0.1:9092";
        String topic = "demo_java";

        // create consumer configs
        Properties properties = new Properties();
        properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

        // create consumer
        KafkaConsumer<String, String> consumer = new KafkaConsumer<String, String>(properties);

        // assign and seek are mostly used to replay data or fetch a specific message

        // assign
        TopicPartition partitionToReadFrom = new TopicPartition(topic, 0);
        long offsetToReadFrom = 7L;
        consumer.assign(Arrays.asList(partitionToReadFrom));

        // seek
        consumer.seek(partitionToReadFrom, offsetToReadFrom);

        int numberOfMessagesToRead = 5;
        boolean keepOnReading = true;
        int numberOfMessagesReadSoFar = 0;

        // poll for new data
        while(keepOnReading){
            ConsumerRecords<String, String> records =
                    consumer.poll(Duration.ofMillis(100));

            for (ConsumerRecord<String, String> record : records){
                numberOfMessagesReadSoFar += 1;
                log.info("Key: " + record.key() + ", Value: " + record.value());
                log.info("Partition: " + record.partition() + ", Offset:" + record.offset());
                if (numberOfMessagesReadSoFar >= numberOfMessagesToRead){
                    keepOnReading = false; // to exit the while loop
                    break; // to exit the for loop
                }
            }
        }

        log.info("Exiting the application");

    }
}


// Here we want to read messages from the offset 7 of partition 0 of the topic demo_java.
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Key: null, Value: hello world 1
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Partition: 0, Offset:7
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Key: null, Value: hello world 2
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Partition: 0, Offset:8
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Key: null, Value: hello world 3
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Partition: 0, Offset:9
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Key: null, Value: hello world 4
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Partition: 0, Offset:10
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Key: null, Value: hello world 5
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Partition: 0, Offset:11
//[main] INFO io.demo.kafka.readfromspecificpartitionsandoffsets.ConsumerSeekAndAssign - Exiting the application