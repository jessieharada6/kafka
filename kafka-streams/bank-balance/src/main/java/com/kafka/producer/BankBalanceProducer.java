package com.kafka.producer;

import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;

import java.time.Instant;
import java.util.Properties;
import java.util.concurrent.ThreadLocalRandom;

public class BankBalanceProducer {
    public static void main(String[] args) {
        String bootstrapServer = "127.0.0.1:9092";
        Properties properties = new Properties();
        // bootstrap server
        properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
        properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        // producer setup
        properties.setProperty(ProducerConfig.ACKS_CONFIG, "all"); // both leader and ISR receive messages and ack them
        properties.setProperty(ProducerConfig.RETRIES_CONFIG, "3"); // retry so we dont loss data
        properties.setProperty(ProducerConfig.LINGER_MS_CONFIG, "1"); //

        // idempotent producer from kafka 0.11
        properties.setProperty(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG, "true");

        // create Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(properties);

        int i = 1;
        while(true) {
            try {
                producer.send(getRandomTransactions("Steph"));
                Thread.sleep(100);
                producer.send(getRandomTransactions("JoJo"));
                Thread.sleep(100);
                producer.send(getRandomTransactions("Sasha"));
                Thread.sleep(100);
            } catch(InterruptedException ex) {
                break;
            }
        }
        producer.close();
    }

    public static ProducerRecord<String, String> getRandomTransactions(String name) {
        ObjectNode transaction = JsonNodeFactory.instance.objectNode(); // empty json object

        Integer randomAmount = ThreadLocalRandom.current().nextInt(0, 100); // generate random amount [0, 100]
        Instant now = Instant.now();

        transaction.put("name", name);
        transaction.put("amount", randomAmount);
        transaction.put("time", now.toString());
        return new ProducerRecord<String, String>("bank-balance-input", name, transaction.toString());
    }
}
