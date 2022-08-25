package com.kafka.test;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.kafka.producer.BankBalanceProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class BankBalanceProducerTest {
    @Test
    public void getRandomTransactionTest() {
        ProducerRecord<String, String> record = BankBalanceProducer.getRandomTransactions("Jo");

        assertEquals(record.key(), "Jo");

        ObjectMapper mapper = new ObjectMapper();
        try{
            JsonNode node = mapper.readTree(record.value());
            assertEquals(node.get("name").asText(), "Jo");
            assertTrue("Amount should be less than 100", node.get("amount").asInt() < 100);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
