package io.demo.kafka;

import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.errors.WakeupException;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

public class ConsumerCoorperative {
    private static final Logger log = LoggerFactory.getLogger(ProducerKeyless.class.getSimpleName());
    public static void main(String[] args) {
        log.info("Hey Kafka Consumer with Shutdown");

        String bootstrapServer = "127.0.0.1:9092";
        String groupId = "second-application"; // note used a new consumer group to consume all messages
        String topic = "demo_java";

        // Consumer Properties
        Properties properties = new Properties();
        // "bootstrap.servers"
        properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
        properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        // auto.offset.reset
        properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        properties.setProperty(ConsumerConfig.PARTITION_ASSIGNMENT_STRATEGY_CONFIG, CooperativeStickyAssignor.class.getName());
        // assign a group id to the consumer group
        // if you set group.id properly, when consumer is restarted it will belong to same group, and will start reading data from where it last stopped.
        properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, "");
//        // assign id to a consumer, can put in a method or put in the constructor
//        properties.setProperty(ConsumerConfig.GROUP_INSTANCE_ID_CONFIG, "");

        // Create consumer
        KafkaConsumer<String, String> consumer = new KafkaConsumer<>(properties);

        // get a reference to the current thread,
        // as the shutdown hook is going to run a diff thread from the main thread
        final Thread mainThread = Thread.currentThread();

        // adding the shutdown hook
        Runtime.getRuntime().addShutdownHook(new Thread(){
            public void run() {
                log.info("Detected a shutdown, let's exit by calling consumer.wakeup()");
                consumer.wakeup(); // abort polling
                // consumer.wakeup() triggers exeption on consumer.poll()
                // wakeup() will cause WakeupException when we wait for main thread to finish
                // as polling is blocking at the main thread
                try {
                    // wait for the code in the main thread to finish by joining
                    // until main thread dies
                    mainThread.join();
                    // interrupted
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });

        // as consumer.wakeup() will throw exception, add it in the try block
        try {
            // Subscribe consumer to the topic(s)
            // to a single topic
            consumer.subscribe(Collections.singletonList(topic));

            // poll kafka
            while(true) {
                log.info("Polling");

                // poll if there are records/messages
                // if no records, wait for 100ms, and go to the next line
                ConsumerRecords<String, String> records
                        = consumer.poll(Duration.ofMillis(100));

                // process message before calling consumer.poll() again
                for(ConsumerRecord<String, String> record : records) {
                    log.info("Key: " + record.key() + " , Value: " + record.value());
                    log.info("Partition: " + record.partition() + " , Offset: " + record.offset());
                }
            }
        } catch (WakeupException e) {
            log.info("Wakeup exception");
            // Ignore it, as it is an expected exception when closing a consumer
        } catch (Exception e) {
            log.error("Unexpected exception");
        } finally {
            // regardless of whether the exception is expected or not,
            // gracefully close consumer and close kafka
            // consumer in the consumer group will properly rebalance and commit offsets if needed
            consumer.close();
            log.info("The consumer is now gracefully closed");
        }
    }
}

// note main thread is diff from shutdown thread (Thread-0)
//[main] INFO ProducerKeyless - Polling -- consumer.poll()
//[Thread-0] INFO ProducerKeyless - Detected a shutdown, let's exit by calling consumer.wakeup()  -- consumer.wakeup()
//[main] INFO ProducerKeyless - Wakeup exception -- mainThread.join() leads to exception