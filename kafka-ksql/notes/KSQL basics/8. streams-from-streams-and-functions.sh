# create stream using script 
run script '/Users/jessieharada/Desktop/kafka/kafka-ksql/ksql-course/user_profile_pretty.ksql';

# script details
-- Change scope default to earliest
SET 'auto.offset.reset'='earliest';

-- Now generate 
create stream user_profile_pretty as 
select firstname + ' ' 
+ ucase( lastname) 
+ ' from ' + countrycode 
+ ' has a rating of ' + cast(rating as varchar) + ' stars. ' 
+ case when rating < 2.5 then 'Poor'
       when rating between 2.5 and 4.2 then 'Good'
       else 'Excellent' 
   end as description
from userprofile;

# list streams
list streams;

 Stream Name         | Kafka Topic                 | Key Format | Value Format | Windowed 
------------------------------------------------------------------------------------------
 KSQL_PROCESSING_LOG | default_ksql_processing_log | KAFKA      | JSON         | false    
 USERPROFILE         | USERPROFILE                 | KAFKA      | JSON         | false    
 USER_PROFILE_PRETTY | USER_PROFILE_PRETTY         | KAFKA      | JSON         | false    
------------------------------------------------------------------------------------------

# see script 
describe USER_PROFILE_PRETTY extended;

###################### BUILD LOGIC ON TOP OF LOGIC aka: streams on top of streams ######################
# see description
select description from user_profile_pretty;
+----------------------------------------------------------------------------------------------------------------------------------------+
|DESCRIPTION                                                                                                                             |
+----------------------------------------------------------------------------------------------------------------------------------------+
|Alison SMITH from GB has a rating of 4.7 stars. Excellent

# drop stream
drop stream user_profile_pretty;

 Message                                                                
------------------------------------------------------------------------
 Source `USER_PROFILE_PRETTY` (topic: USER_PROFILE_PRETTY) was dropped. 
------------------------------------------------------------------------

# if errored out
# the following queries write into this source : [abc]
terminate query abc;
drop stream user_profile_pretty;
list streams;

drop stream if exists user_profile_pretty delete topic;

 Message                                      
----------------------------------------------
 Source `USER_PROFILE_PRETTY` does not exist. 
----------------------------------------------