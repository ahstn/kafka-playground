Once the `ksql-cli` container is alive, or the `control-center`, you can create ksqlDB streams.

- ksqlDB CLI: `docker exec -it ksqldb-cli ksql http://ksqldb-server:8088`
- Control Center: `open http://localhost:9021/clusters/`

In the ksqlDB CLI, you can create a stream and perform transformations:

```sql
CREATE STREAM users_stream (userid VARCHAR, regionid VARCHAR)
  WITH (KAFKA_TOPIC='users-topic', VALUE_FORMAT='AVRO');

-- Create a derived stream with transformations
CREATE STREAM users_transformed AS
  SELECT user_id, FROM users_stream WHERE ...;
```

Replace user_id and ... with the relevant fields and transformations specific to your use case. The `CREATE STREAM users_transformed AS SELECT` statement creates a new derived stream with the transformed data.

You can then use ksqlDB to query the transformed stream in real-time:

```sql
SELECT * FROM users_transformed EMIT CHANGES;
```

This command will continuously output the results from the users_transformed stream as new records are processed.

Remember to replace the example fields and transformations with the ones relevant to your specific use case.

CREATE STREAM users_transformed AS SELECT user_id FROM 'my-topic';
