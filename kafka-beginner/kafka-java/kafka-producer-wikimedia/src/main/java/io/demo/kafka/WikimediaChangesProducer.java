package io.demo.kafka;

import com.launchdarkly.eventsource.EventHandler;
import com.launchdarkly.eventsource.EventSource;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;

import java.net.URI;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

public class WikimediaChangesProducer {
    public static void main(String[] args) throws InterruptedException {
        // create Producer properties
        String bootstrapServer = "127.0.0.1:9092";
        Properties properties = new Properties();
        properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
        properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        // batching and compression - high throughput producer configs
        properties.setProperty(ProducerConfig.LINGER_MS_CONFIG, "20"); // "linger.ms" -> 20ms
        properties.setProperty(ProducerConfig.BATCH_SIZE_CONFIG, Integer.toString(32 * 1024)); // "batch.size" -> 32KB
        properties.setProperty(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy"); // "compression.type" -> algo

        // create Producer
        KafkaProducer<String, String> producer = new KafkaProducer<>(properties);

        // remember to create a topic using cli
        // kafka-topics.sh --bootstrap-server localhost:9092 --topic wikimedia.recentchange --create --partitions 3 --replication-factor 1
        String topic = "wikimedia.recentchange";

        // handle event from stream, and send the stream to producer
        EventHandler eventHandler = new WikimediaChangeHandler(producer, topic);
        String url = "https://stream.wikimedia.org/v2/stream/recentchange";
        EventSource.Builder builder = new EventSource.Builder(eventHandler, URI.create(url));
        EventSource eventSource = builder.build();

        // start the producer in another thread, as producer now is part of the obj of event handler
        // this is going to start in another(worker) thread, not main thread
        // so block using time unit, so that the main thread won't finish (because if main thread is finished, all other threads will be finished too)
        eventSource.start();

        // we produce for 10 mins and block the program until then
        TimeUnit.MINUTES.sleep(10); // add InterruptedException at the main method
    }
}


// EventHandler:
// Server-Sent Events (SSE) is a server push technology
// enabling a client to receive automatic updates from a server via an HTTP connection,
// and describes how servers can initiate data transmission towards clients
// once an initial client connection has been established.