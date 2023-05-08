FROM rust:1.69 AS build
WORKDIR /usr/src/kafka_consumer
COPY . .
RUN cargo build --release


FROM rust:1.69-slim
WORKDIR /app
COPY --from=build /usr/src/kafka_consumer/target/release/kafka_consumer .
ENTRYPOINT ["./kafka_consumer"]