cd testing

# the below will fail
# log everything
ksql-test-runner --sql-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/ksql-statements.ksql --input-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/input.json --output-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/output.json

# just to get result of the test
ksql-test-runner --sql-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/ksql-statements.ksql --input-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/input.json --output-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/output.json  | grep  ">>>"
Test failed: Topic 'CARSIZE_BUCKETS', message 1: Expected <2, {"CARSIZE_RESULT":"large"}> with timestamp=0 and headers=[] but was <2, {CARSIZE_RESULT=huge}> with timestamp=0 and headers=[]

# this should succeed
ksql-test-runner --sql-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/ksql-statements-enhanced.ksql --input-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/input.json --output-file /Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/testing/output.json  | grep  ">>>"
 Test passed!