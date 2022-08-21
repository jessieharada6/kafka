package com.simplesteph.kafka;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.kafka.common.config.ConfigDef;
import org.apache.kafka.connect.connector.Task;
import org.apache.kafka.connect.source.SourceConnector;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GitHubSourceConnector extends SourceConnector {
    private static Logger log = LoggerFactory.getLogger(GitHubSourceConnector.class);
    private GitHubSourceConnectorConfig config;

    @Override
    public String version() {
        return VersionUtil.getVersion();
    }

    @Override
    // create source connector properties - GitHubSourceConnectorExample.properties
    // pass the properties to the connector config
    public void start(Map<String, String> map) {
        config = new GitHubSourceConnectorConfig(map);
    }

    @Override
    public Class<? extends Task> taskClass() {
        return GitHubSourceTask.class;
    }

    @Override
    // source connector can't be parallalised, so it will always be 1 task
    public List<Map<String, String>> taskConfigs(int i) {
        // Define the individual task configurations that will be executed.
        ArrayList<Map<String, String>> configs = new ArrayList<>(1);
        // return the map from start()
        configs.add(config.originalsStrings());
        return configs;
    }

    @Override
    // stop the connector
    // for example, if upon start, we open a database
    // here is a good place to close the connection string
    public void stop() {
        // Do things that are necessary to stop your connector.
        // nothing is necessary to stop for this connector
    }

    @Override
    public ConfigDef config() {
        return GitHubSourceConnectorConfig.conf();
    }
}
