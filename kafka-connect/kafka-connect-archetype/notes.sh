# use the maven below
https://mvnrepository.com/artifact/io.confluent.maven/kafka-connect-quickstart/0.10.0.0

# <!-- https://mvnrepository.com/artifact/io.confluent.maven/kafka-connect-quickstart -->
<dependency>
    <groupId>io.confluent.maven</groupId>
    <artifactId>kafka-connect-quickstart</artifactId>
    <version>0.10.0.0</version>
</dependency>


# if encounter https://stackoverflow.com/questions/67001968/how-to-disable-maven-blocking-external-http-repositories
# at /Users/username
touch ~/.m2/settings.xml 
vim ~/.m2/settings.xml 
# insert below
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 http://maven.apache.org/xsd/settings-1.2.0.xsd">
     <mirrors>
          <mirror>
               <id>maven-default-http-blocker</id>
               <mirrorOf>dummy</mirrorOf>
               <name>Dummy mirror to override default blocking mirror that blocks http</name>
               <url>http://0.0.0.0/</url>
         </mirror>
    </mirrors>
</settings>