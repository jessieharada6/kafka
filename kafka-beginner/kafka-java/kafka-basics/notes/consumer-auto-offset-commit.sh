# start consumer

# doc: https://docs.confluent.io/platform/current/clients/consumer.html
# consumer auto offset commit by default
# at-least-once mode by default: messages may be read again
# - async commits, no missing messages but may duplicate
# offsets commited when calling consumer.poll()

# at-most-once: 
# know if the commit succeeded before consuming the message. 
# This implies a synchronous commit unless you have the ability to “unread” a message after you find that the commit failed.

# exactly once processing - kafka streams 

auto.commit.interval.ms = 5000
enable.auto.commit = true

# auto commit every 5 seconds, behind the scene, call commitAsync()

# poll if there are records/messages
# if no records, wait for 100ms, and go to the next line
ConsumerRecords<String, String> records
        = consumer.poll(Duration.ofMillis(100));

# process message before calling consumer.poll() again!!!
# otherwie won't be in at-least-once mode
for(ConsumerRecord<String, String> record : records) {
    log.info("Key: " + record.key() + " , Value: " + record.value());
    log.info("Partition: " + record.partition() + " , Offset: " + record.offset());
}


# https://www.madhur.co.in/blog/2021/07/18/meaning-of-at-least-once-at-most-once-and-exactly-once-delivery.html#:~:text=As%20the%20name%20suggests%2C%20At,committing%20the%20last%20offset%20used.
# Meaning of at-least once, at-most once and exactly-once delivery

# Ever since I have started working with Kafka, I have came across these terms very frequently, At-least once, At-most once and Exactly Once.

# As an engineer, It is very important to understand these concepts.

# At-most once Configuration
# As the name suggests, At-most-once means the message will be delivered at-most once. Once delivered, there is no chance of delivering again. If the consumer is unable to handle the message due to some exception, the message is lost. This is because Kafka is automatically committing the last offset used.

# Set enable.auto.commit to true
# Set auto.commit.interval.ms to low value
# Since auto.commit is set to true, there is no need to call consumer.commitSync() from the consumer.
# Note that it is also possible to have at-lest-once scenario with the same configuration. Let’s say consumer successfully processed the message successfully into its store and in the meantime before kafka could commit the offset, consumer was restarted. In this scenario, consumer would again get the same message.

# Hence, even if using at-most once or at-least once configuration, consumer should be always prepared to handle the duplicates.

# At-least once configuration
# At-least once as the name suggests, message will be delivered atleast once. There is high chance that message will be delivered again as duplicate.

# Set enable.auto.commit to false OR
# Consumer should now then take control of the message offset commits to Kafka by making the consumer.commitSync() call.
# Let’s say consumer has processed the messages and committed the messages to its local store, but consumer crashes and did not get a chance to commit offset to Kafka before it has crashed. When consumer restarts, Kafka would deliver messages from the last offset, resulting in duplicates.

# Exactly-once configuration
# Exactly-once as the name suggests, there will be only one and once message delivery. It difficult to achieve in practice.

# In this case offset needs to be manually managed.

# Set enable.auto.commit to false
# Do not make call to consumer.commitSync()
# Implement a ConsumerRebalanceListener and within the listener perform consumer.seek(topicPartition,offset); to start reading from a specific offset of that topic/partition.
# While processing the messages, get hold of the offset of each message. Store the processed message’s offset in an atomic way along with the processed message using atomic-transaction. When data is stored in relational database atomicity is easier to implement. For non-relational data-store such as HDFS store or No-SQL store one way to achieve atomicity is as follows: Store the offset along with the message.