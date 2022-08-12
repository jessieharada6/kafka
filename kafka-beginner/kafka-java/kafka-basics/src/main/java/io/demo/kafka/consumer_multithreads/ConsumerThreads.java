package io.demo.kafka.consumer_multithreads;

import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.common.errors.WakeupException;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.util.Collections;
import java.util.Date;
import java.util.Properties;
import java.util.concurrent.CountDownLatch;

// https://www.conduktor.io/kafka/java-consumer-in-threads
public class ConsumerThreads {
    public static void main(String[] args)  {
        ConsumerDemoWorker consumerDemoWorker = new ConsumerDemoWorker();
        // consumer thread - thread-2
        new Thread(consumerDemoWorker).start();
        // shutdown thread - thread-1
        Runtime.getRuntime().addShutdownHook(new Thread(new ConsumerDemoCloser(consumerDemoWorker)));
    }

    private static class ConsumerDemoWorker implements Runnable {

        private static final Logger log = LoggerFactory.getLogger(ConsumerDemoWorker.class);

        private CountDownLatch countDownLatch;
        private Consumer<String, String> consumer;

        @Override
        public void run() {
            countDownLatch = new CountDownLatch(1);
            final Properties properties = new Properties();

            properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
            properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
            properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
            properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, "my-sixth-application");
            properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");

            consumer = new KafkaConsumer<>(properties);
            consumer.subscribe(Collections.singleton("demo_java"));

            final Duration pollTimeout = Duration.ofMillis(100);

            try {
                while (true) {
                    final ConsumerRecords<String, String> consumerRecords = consumer.poll(pollTimeout);
                    for (final ConsumerRecord<String, String> consumerRecord : consumerRecords) {
                        log.info("Getting consumer record key: '" + consumerRecord.key() + "', value: '" + consumerRecord.value() + "', partition: " + consumerRecord.partition() + " and offset: " + consumerRecord.offset() + " at " + new Date(consumerRecord.timestamp()));
                    }
                }
            } catch (WakeupException e) {
                log.info("Consumer poll woke up");
            } finally {
                consumer.close();
                countDownLatch.countDown();
            }
        }

        void shutdown() throws InterruptedException {
            consumer.wakeup();
            countDownLatch.await();
            log.info("Consumer closed");
        }

    }

    private static class ConsumerDemoCloser implements Runnable {

        private static final Logger log = LoggerFactory.getLogger(ConsumerDemoCloser.class);

        private final ConsumerDemoWorker consumerDemoWorker;

        ConsumerDemoCloser(final ConsumerDemoWorker consumerDemoWorker) {
            this.consumerDemoWorker = consumerDemoWorker;
        }

        @Override
        public void run() {
            try {
                consumerDemoWorker.shutdown();
            } catch (InterruptedException e) {
                log.error("Error shutting down consumer", e);
            }
        }
    }
}

//[Thread-0] INFO io.demo.kafka.consumer_multithreads.ConsumerThreads$ConsumerDemoWorker - Consumer poll woke up
//[Thread-0] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-my-sixth-application-1, groupId=my-sixth-application] Revoke previously assigned partitions demo_java-0, demo_java-1, demo_java-2
//[Thread-0] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-my-sixth-application-1, groupId=my-sixth-application] Member consumer-my-sixth-application-1-78596cd3-2860-43bf-8175-f1efd595afd0 sending LeaveGroup request to coordinator localhost:9092 (id: 2147483647 rack: null) due to the consumer is being closed
//[Thread-0] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-my-sixth-application-1, groupId=my-sixth-application] Resetting generation and member id due to: consumer pro-actively leaving the group
//[Thread-0] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-my-sixth-application-1, groupId=my-sixth-application] Request joining group due to: consumer pro-actively leaving the group
//[Thread-0] INFO org.apache.kafka.common.metrics.Metrics - Metrics scheduler closed
//[Thread-0] INFO org.apache.kafka.common.metrics.Metrics - Closing reporter org.apache.kafka.common.metrics.JmxReporter
//[Thread-0] INFO org.apache.kafka.common.metrics.Metrics - Metrics reporters closed
//[Thread-0] INFO org.apache.kafka.common.utils.AppInfoParser - App info kafka.consumer for consumer-my-sixth-application-1 unregistered
//[Thread-1] INFO io.demo.kafka.consumer_multithreads.ConsumerThreads$ConsumerDemoWorker - Consumer closed
