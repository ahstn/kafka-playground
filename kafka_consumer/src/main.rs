use rdkafka::config::ClientConfig;
use rdkafka::consumer::{CommitMode, Consumer, StreamConsumer};
use rdkafka::message::{Headers, Message};
use std::env;

#[tokio::main]
async fn main() {
    let broker = env::var("KAFKA_BROKER_URL").unwrap_or_else(|_| "localhost:9092".to_string());
    let topic = env::var("KAFKA_TOPIC").expect("KAFKA_TOPIC must be set");

    let consumer: StreamConsumer = ClientConfig::new()
        .set("bootstrap.servers", broker)
        .set("group.id", "rust_consumer")
        .set("auto.offset.reset", "earliest")
        .create()
        .expect("Failed to create consumer");

    consumer
        .subscribe(&[&topic])
        .expect("Failed to subscribe to topic");

    loop {
        match consumer.recv().await {
            Err(e) => println!("Error while receiving from Kafka: {:?}", e),
            Ok(message) => {
                let payload = match message.payload_view::<str>() {
                    None => "".to_string(),
                    Some(Err(e)) => {
                        println!("Error while deserializing message payload: {:?}", e);
                        "".to_string()
                    }
                    Some(Ok(s)) => s.to_string(),
                };

                println!(
                    "Message received: topic={}, partition={}, offset={}, payload={}",
                    message.topic(),
                    message.partition(),
                    message.offset(),
                    payload
                );

                consumer
                    .commit_message(&message, CommitMode::Async)
                    .unwrap()
            }
        }
    }
}
