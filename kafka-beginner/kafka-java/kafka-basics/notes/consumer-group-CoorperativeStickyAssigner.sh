# properties.setProperty(ConsumerConfig.PARTITION_ASSIGNMENT_STRATEGY_CONFIG, CooperativeStickyAssignor.class.getName());
#  
# Assigned partitions: currently assigned partition
# Current owned partitions: what you have before the newly added consumer
# Added partitions (assigned - owned): newly distributed partition
# Revoked partitions: will go to the newly added consumer
Assigned partitions:                       [demo_java-0, demo_java-2]
Current owned partitions:                  []
Added partitions (assigned - owned):       [demo_java-0, demo_java-2]
Revoked partitions (owned - assigned):     []