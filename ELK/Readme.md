# ELK

1. Elasticsearch: a distributed RESTful search engine which stores all of the collected data.

2. Logstash: the data processing component of the Elastic Stack which sends incoming data to Elasticsearch.

3. Kibana: a web interface for searching and visualizing logs.

4. Beats: lightweight, single-purpose data shippers that can send data from hundreds or thousands of machines to either Logstash or Elasticsearch.

- Filebeat: collects and ships log files.
- Metricbeat: collects metrics from your systems and services.
- Packetbeat: collects and analyzes network data.
- Winlogbeat: collects Windows event logs.
- Auditbeat: collects Linux audit framework data and monitors file integrity.
- Heartbeat: monitors services for their availability with active probing.

## Elastic Stack Installation

Note: When installing the Elastic Stack, you must use the same version across the entire stack. In this tutorial we will install the latest versions of the entire stack which are, at the time of this writing, Elasticsearch 7.7.1, Kibana 7.7.1, Logstash 7.7.1, and Filebeat 7.7.1.

### Install java

`sudo apt update`

`sudo apt install default-jre`

`sudo apt install default-jdk`

`sudo update-alternatives --config java`

`sudo nano /etc/environment`

`JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"`

`source /etc/environment`

`export PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/bin`

`export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64`

### Local script ELK installation

`curl -fsSL https://elastic.co/start-local | sh`

Install from 7.10x "https://www.elastic.co/support/matrix"

### Elastic Search Installation

`curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch |sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg`

`echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list`

`sudo apt update`

`sudo apt install elasticsearch -y`

`sudo nano /etc/elasticsearch/elasticsearch.yml`

Modify:
```yaml
network.host: 0.0.0.0
cluster.name: my-cluster
node.name: node-1
discovery.type: single-node
```

`sudo systemctl start elasticsearch`

`sudo systemctl enable elasticsearch`

`sudo systemctl status elasticsearch`

`curl -X GET "localhost:9200"`

### Logstash Installation

`sudo apt install logstash -y`

`sudo nano /etc/logstash/conf.d/logstash.conf`

Add:

```yaml
input {
 beats {
  port => 5044
 }
}

filter {
 grok {
  match => { "message" => "%{TIMESTAMP_ISO8601:log_timestamp} %{LOGLEVEL:log_level}
%{GREEDYDATA:log_message}" }
 }
}

output {
 elasticsearch {
  hosts => ["http://localhost:9200"]
  index => "logs-%{+YYYY.MM.dd}"
 }
stdout { codec => rubydebug }
}
```

`sudo systemctl start logstash`

`sudo systemctl enable logstash`

`sudo systemctl status logstash`

### Kibana Installation

`sudo apt install kibana -y`

`sudo nano /etc/kibana/kibana.yml`

Modify:
```yaml
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
```

`sudo systemctl enable kibana`

`sudo systemctl start kibana`

`sudo systemctl status kibana`

http://<ELK_Server_Public_IP>:5601

### Filebeat Installation

`wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -`

`echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list`

`sudo apt update`

`sudo apt install filebeat -y`

`sudo nano /etc/filebeat/filebeat.yml`

```yaml
filebeat.inputs:
- type: log
enabled: true
paths:
- /home/ubuntu/Boardgame/target/app.log

output.logstash:
hosts: ["<ELK_Server_Private_IP>:5044"]
```

`sudo systemctl start filebeat`

`sudo systemctl enable filebeat`

`sudo systemctl status filebeat`

`sudo filebeat test output`

NOTE: The functionality of Filebeat can be extended with Filebeat modules.In this we will use the system module, which collects and parses logs created by the system logging service of common Linux distributions.

`sudo filebeat modules enable system`

`sudo filebeat modules list`

Check for configs `/etc/filebeat/modules.d/system.yml`

Set up the Filebeat ingest pipelines, which parse the log data before sending it through logstash to Elasticsearch

`sudo filebeat setup --pipelines --modules system`

Load the index template into Elasticsearch

`sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["localhost:9200"]'`

Filebeat comes packaged with sample Kibana dashboards that allow you to visualize Filebeat data in Kibana. Before you can use the dashboards, you need to create the index pattern and load the dashboards into Kibana.

As the dashboards load, Filebeat connects to Elasticsearch to check version information. To load dashboards when Logstash is enabled, you need to disable the Logstash output and enable Elasticsearch output:

`sudo filebeat setup -E output.logstash.enabled=false -E output.elasticsearch.hosts=['localhost:9200'] -E setup.kibana.host=localhost:5601`

`sudo systemctl start filebeat`

`sudo systemctl status filebeat`

`curl -XGET 'http://localhost:9200/filebeat-*/_search?pretty'`