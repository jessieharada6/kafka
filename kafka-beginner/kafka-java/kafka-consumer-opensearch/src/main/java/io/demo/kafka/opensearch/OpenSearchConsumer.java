package io.demo.kafka.opensearch;

import com.google.gson.JsonParser;
import org.apache.http.HttpHost;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultConnectionKeepAliveStrategy;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.opensearch.action.bulk.BulkRequest;
import org.opensearch.action.bulk.BulkResponse;
import org.opensearch.action.index.IndexRequest;
import org.opensearch.action.index.IndexResponse;
import org.opensearch.client.Request;
import org.opensearch.client.RequestOptions;
import org.opensearch.client.RestClient;
import org.opensearch.client.RestHighLevelClient;
import org.opensearch.client.indices.CreateIndexRequest;
import org.opensearch.client.indices.GetIndexRequest;
import org.opensearch.common.xcontent.XContentType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URI;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

public class OpenSearchConsumer {
    public static void main(String[] args) throws IOException {
        Logger logger = LoggerFactory.getLogger(OpenSearchConsumer.class.getSimpleName());
        // create an OpenSearch Client
        RestHighLevelClient openSearchClient = createOpenSearchClient();
        
        // create a kafka client
        KafkaConsumer<String, String> consumer = createKafkaConsumer();

        // try(openSearchClient) does openSearchClient.close() after executing this block
        // try(consumer) does consumer.close() after executing this block
        try(openSearchClient; consumer) {
            // create index on OpenSearch if it does not exist already
            boolean indexExists =
                    openSearchClient.indices().exists(new GetIndexRequest("wikimedia"), RequestOptions.DEFAULT);
            if (!indexExists) {
                CreateIndexRequest createIndexRequest = new CreateIndexRequest("wikimedia");
                openSearchClient.indices().create(createIndexRequest, RequestOptions.DEFAULT);
                logger.info("Wikimedia index has been created!");
            } else {
                logger.info("Wikimedia index already exists");
            }

            // subscribe to the topic
            consumer.subscribe(Collections.singletonList("wikimedia.recentchange"));

            // consumer polls records
            while(true) {
                // hold the list of consumer record per partition
                ConsumerRecords<String, String> records = consumer.poll(Duration.ofMillis(3000));
                int recordCount = records.count();
                logger.info("Received " + recordCount + " record(s)");

                BulkRequest bulkRequest = new BulkRequest();
                for(ConsumerRecord<String, String> record : records) {
                    // send record to OpenSearch
                    try {
                        // insert unique id to opensearch, to let opensearch know any duplicates
                        // once opensearch defects any duplicates based on id, it will update and not have duplicates
                        // in turn, we made *** consumer IDEMPOTENT ***: at least once + idempotent = exactly once
                        // strategy 1
                        // String id = record.topic() + "_" + record.partition() + "_" + record.offset();
                        // strategy 2: use the record id under meta
                        String id = extractId(record.value());
                        // create IndexRequest
                        IndexRequest indexRequest = new IndexRequest("wikimedia")
                                .source(record.value(), XContentType.JSON)
                                // it was in format of5T3JoIIBw5s1buzmILdI,
                                // now it will be format of 5f416870-5dfb-4101-b5a4-bd5ef73d1c1e as we extracted id
                                .id(id);

                        bulkRequest.add(indexRequest); // fill up bulk request

                        // currently, inefficient
                        // index the record for every index request for every single record comes in
                        //IndexResponse response = openSearchClient.index(indexRequest, RequestOptions.DEFAULT);
                        //logger.info("Inserted 1 document into OpenSearch - id of " + response.getId());

                    } catch (Exception e) {

                    }
                }
                // after the for loop where it adds all the bulk request actions
                // send to opensearch and commit offsets only if bulk request has actions
                if (bulkRequest.numberOfActions() > 0) {
                    // now, more efficient - data sends to opensearch in bulk
                    BulkResponse responses = openSearchClient.bulk(bulkRequest, RequestOptions.DEFAULT);
                    logger.info("Inserted " + responses.getItems().length + " records");

                    try {
                        Thread.sleep(100); // add more chances of getting bulk request actions
                    } catch (InterruptedException e) {
                        throw new RuntimeException(e);
                    }

                    // commit offsets after the batch is consumed
                    // because properties.setProperty(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
                    //consumer.commitSync();
                }
            }
        }
    }

    private static String extractId(String json) {
        return JsonParser.parseString(json).getAsJsonObject()
                .get("meta").getAsJsonObject()
                .get("id").getAsString();
    }

    private static RestHighLevelClient createOpenSearchClient() {
        String connString = "http://localhost:9200"; // use docker
        // String connString = "https://c9p5mwld41:45zeygn9hy@kafka-course-2322630105.eu-west-1.bonsaisearch.net:443"; // user bonsai (at access -> credentials)

        // we build a URI from the connection string
        RestHighLevelClient restHighLevelClient;
        URI connUri = URI.create(connString);
        // extract login information if it exists
        String userInfo = connUri.getUserInfo();

        if (userInfo == null) {
            // REST client without security
            restHighLevelClient = new RestHighLevelClient(RestClient.builder(new HttpHost(connUri.getHost(), connUri.getPort(), "http")));
        }
        else
        {
            // REST client with security
            String[] auth = userInfo.split(":");

            CredentialsProvider cp = new BasicCredentialsProvider();
            cp.setCredentials(AuthScope.ANY, new UsernamePasswordCredentials(auth[0], auth[1]));

            restHighLevelClient = new RestHighLevelClient(
                    RestClient.builder(new HttpHost(connUri.getHost(), connUri.getPort(), connUri.getScheme()))
                            .setHttpClientConfigCallback(
                                    httpAsyncClientBuilder -> httpAsyncClientBuilder.setDefaultCredentialsProvider(cp)
                                            .setKeepAliveStrategy(new DefaultConnectionKeepAliveStrategy())));
        }

        return restHighLevelClient;
    }
    private static KafkaConsumer<String, String> createKafkaConsumer() {
        String bootstrapServer = "127.0.0.1:9092";
        String groupId = "consumer-opensearch";

        // Consumer Properties
        Properties properties = new Properties();
        properties.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServer);
        properties.setProperty(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        properties.setProperty(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        properties.setProperty(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest"); // can be earliest
        // make ENABLE_AUTO_COMMIT_CONFIG false alone
        // consumer won't commit offset automatically, lag will always remain the same - kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group consumer-opensearch
        // everytime the consumer starts, it reads from the beginning
        //properties.setProperty(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");

        // Create consumer
        return new KafkaConsumer<>(properties);
    }
}



// to check lag on topic
// kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group consumer-opensearch

// to query at http://localhost:5601/app/dev_tools#/console,
// start both producer and consumer, get a key from consumer log ([main] INFO OpenSearchConsumer - Inserted 1 document into OpenSearch - id of 5T3JoIIBw5s1buzmILdI)
// GET /wikimedia/_doc/5T3JoIIBw5s1buzmILdI