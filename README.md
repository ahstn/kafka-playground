# Kafka Examples

## Usage

Start the Docker stack:

```bash
# start containers - add '-d' to run in background
docker-compose up

# check containers and health
docker-compose ps
```

Once everything is health is up, you can access the following services:

- Kafka UI: http://localhost:8080/
  - See: [Kafka UI | GitHub][kafka ui]
- Confluent Control Center: http://localhost:9021/clusters
  - See: [Control Center Quickstart | Confluent][confluent control center]

## Kafka Connect

By default, Kafka Connect is started with a JDBC connector, to add some config and enable it:

```bash
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
        "name": "jdbc_source_postgres_01",
        "config": {
                "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
                "connection.url": "jdbc:postgresql://postgres:5432/postgres",
                "connection.user": "postgres",
                "connection.password": "postgres",
                "table.whitelist" : "users",
                "topic.prefix": "postgres-01-",
                "mode": "bulk",
                "poll.interval.ms" : 10000,
                "transforms": "createKey",
                "transforms.createKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
                "transforms.createKey.fields": "id",
        }
    }'
```

As per [JDBC Source Connector | Confluent], a `query` can also be specified to limit, filter, or join tables:

```
query=SELECT users.id, users.name, transactions.timestamp, transactions.user_id, transactions.payment FROM users JOIN transactions ON (users.id = transactions.user_id)
```

You can also add extra Kafka Connect JARs by altering the `connect` containers runtime command:

```yaml
services:
  connect:
    command:
      - /bin/bash
      - -c
      - |
        confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.1
        /etc/confluent/docker/run
```

> see [Home | Confluent Hub] for connectors and their JARs

[kafka ui]: https://github.com/provectus/kafka-ui
[confluent control center]: https://docs.confluent.io/platform/current/platform-quickstart.html#quickstart
[home | confluent hub]: https://www.confluent.io/hub/
[JDBC Source Connector | Confluent]: https://docs.confluent.io/kafka-connectors/jdbc/current/source-connector/overview.html#configuration

https://github.com/confluentinc/cp-all-in-one/blob/7.4.0-post/cp-all-in-one-kraft/docker-compose.yml
https://github.com/confluentinc/cp-all-in-one/blob/7.3.0-post/cp-all-in-one/docker-compose.yml
https://github.com/provectus/kafka-ui/blob/master/documentation/compose/kafka-ui.yaml
