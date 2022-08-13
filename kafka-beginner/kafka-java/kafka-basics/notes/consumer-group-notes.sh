# consumer with shutdown
# same group if of "second-application"

# first consumer
# as it is running, it will revoke the current assignment to all partitions -
# Revoke previously assigned partitions demo_java-0, demo_java-1, demo_java-2
# and add new assignment
# Adding newly assigned partitions: demo_java-2
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Request joining group due to: group is already rebalancing
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Revoke previously assigned partitions demo_java-0, demo_java-1, demo_java-2
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Revoke previously assigned partitions 
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] (Re-)joining group
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Successfully joined group with generation Generation{generationId=30, memberId='consumer-second-application-1-b9549c16-6beb-476b-a0a3-4c151384979c', protocol='range'}
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Finished assignment for group at generation 30: {consumer-second-application-1-b9549c16-6beb-476b-a0a3-4c151384979c=Assignment(partitions=[demo_java-2]), consumer-second-application-1-06232986-b893-459d-9831-0c0973e892a1=Assignment(partitions=[demo_java-0, demo_java-1])}
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Successfully synced group in generation Generation{generationId=30, memberId='consumer-second-application-1-b9549c16-6beb-476b-a0a3-4c151384979c', protocol='range'}
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Notifying assignor about the new Assignment(partitions=[demo_java-2])
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Adding newly assigned partitions: demo_java-2
[main] INFO ProducerKeyless - Polling
# as offset has been commited - reset to the most recent commited offsets, so start from where it's been left
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Setting offset for partition demo_java-2 to the committed offset FetchPosition{offset=31, offsetEpoch=Optional[0], currentLeader=LeaderAndEpoch{leader=Optional[localhost:9092 (id: 0 rack: null)], epoch=0}}

# dont stop the first consumer, and start second consumer
# Adding newly assigned partitions: demo_java-0, demo_java-1
# and start on the offset where it's been left
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Successfully joined group with generation Generation{generationId=30, memberId='consumer-second-application-1-06232986-b893-459d-9831-0c0973e892a1', protocol='range'}
[main] INFO ProducerKeyless - Polling
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Successfully synced group in generation Generation{generationId=30, memberId='consumer-second-application-1-06232986-b893-459d-9831-0c0973e892a1', protocol='range'}
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Notifying assignor about the new Assignment(partitions=[demo_java-0, demo_java-1])
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Adding newly assigned partitions: demo_java-0, demo_java-1
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Setting offset for partition demo_java-0 to the committed offset FetchPosition{offset=40, offsetEpoch=Optional[0], currentLeader=LeaderAndEpoch{leader=Optional[localhost:9092 (id: 0 rack: null)], epoch=0}}
[main] INFO org.apache.kafka.clients.consumer.internals.ConsumerCoordinator - [Consumer clientId=consumer-second-application-1, groupId=second-application] Setting offset for partition demo_java-1 to the committed offset FetchPosition{offset=21, offsetEpoch=Optional[0], currentLeader=LeaderAndEpoch{leader=Optional[localhost:9092 (id: 0 rack: null)], epoch=0}}



# when starting producer with key
# first consumer will only read from partition 2
[main] INFO ProducerKeyless - Partition: 2 , Offset: 31
[main] INFO ProducerKeyless - Key: id_4 , Value: hello_world 4
[main] INFO ProducerKeyless - Partition: 2 , Offset: 32
[main] INFO ProducerKeyless - Key: id_5 , Value: hello_world 5
[main] INFO ProducerKeyless - Partition: 2 , Offset: 33
[main] INFO ProducerKeyless - Key: id_7 , Value: hello_world 7
[main] INFO ProducerKeyless - Partition: 2 , Offset: 34
[main] INFO ProducerKeyless - Key: id_9 , Value: hello_world 9
[main] INFO ProducerKeyless - Partition: 2 , Offset: 35
# second consumer will only read from partitin 0 and 1
[main] INFO ProducerKeyless - Key: id_1 , Value: hello_world 1
[main] INFO ProducerKeyless - Partition: 0 , Offset: 40
[main] INFO ProducerKeyless - Key: id_3 , Value: hello_world 3
[main] INFO ProducerKeyless - Partition: 0 , Offset: 41
[main] INFO ProducerKeyless - Key: id_6 , Value: hello_world 6
[main] INFO ProducerKeyless - Partition: 0 , Offset: 42
[main] INFO ProducerKeyless - Key: id_0 , Value: hello_world 0
[main] INFO ProducerKeyless - Partition: 1 , Offset: 21
[main] INFO ProducerKeyless - Key: id_8 , Value: hello_world 8
[main] INFO ProducerKeyless - Partition: 1 , Offset: 22


# when running the third consumer, dont stop the first two
# in the same consumer group (same consumer id), they will rebalance on the partitions again
# as we create a topic with 3 partitions using cli
# one consumer will consume 1 partition