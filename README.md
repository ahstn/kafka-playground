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

> see [Home | Confluent Hub] for connectors and their JARs

For ease of use, some configs have been included in `./connector-config`, and can be used with cURL and `-d @connector-config/<config>.json`.

### Postgres

By default, Kafka Connect is started with a JDBC connector, to add some config and enable it:

```bash
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d @connector-config/jdbc-source.json
```

As per [JDBC Source Connector | Confluent], a `query` can also be specified to limit, filter, or join tables:

```
query=SELECT users.id, users.name, transactions.timestamp, transactions.user_id, transactions.payment FROM users JOIN transactions ON (users.id = transactions.user_id)
```

### Data Generator

Using [Data Generator | Confluent Hub], we can generate test data. To create an example for product data run:

```bash
# Where -d is the config file
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d @connector-config/datagen-product.json
```

### Additional Connectors

You can also add extra Kafka Connect JARs by altering the `connect` containers runtime command:

```yaml
services:
  connect:
    command:
      - /bin/bash
      - -c
      - |
        confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.1
        confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest:latest
        /etc/confluent/docker/run
```

If `value.converter.schema.registry.url` is included, then the schema will be registered in the Schema Registry, as in `datagen-user.json`.

[kafka ui]: https://github.com/provectus/kafka-ui
[confluent control center]: https://docs.confluent.io/platform/current/platform-quickstart.html#quickstart
[home | confluent hub]: https://www.confluent.io/hub/
[JDBC Source Connector | Confluent]: https://docs.confluent.io/kafka-connectors/jdbc/current/source-connector/overview.html#configuration
[data generator | confluent hub]: https://www.confluent.io/hub/confluentinc/kafka-connect-datagen

https://github.com/confluentinc/cp-all-in-one/blob/7.4.0-post/cp-all-in-one-kraft/docker-compose.yml
https://github.com/confluentinc/cp-all-in-one/blob/7.3.0-post/cp-all-in-one/docker-compose.yml
https://github.com/provectus/kafka-ui/blob/master/documentation/compose/kafka-ui.yaml

```

```
