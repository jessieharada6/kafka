
################### ksql-datagen command line tool ####################

# in a new terminal
sudo ln -s confluent-7.2.1 confluent  # symbolic link the folder to use confluent as path
ls /opt/confluent/bin                 # try the path

export PATH=${PATH}:/opt/confluent/bin # path
export CONFLUENT_HOME=/opt/confluent 


# ksql-datagent
# generate live data every second, max rows of data is 100
ksql-datagen schema=/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/datagen/userprofile.avro format=json topic=USERPROFILE key=userid msgRate=1 iterations=100

# see the generated data
print 'USERPROFILE' interval 5;