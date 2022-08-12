# start consumer

# consumer auto offset commit by default
# at-least-once mode by default
# offsets commited when calling consumer.poll()
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