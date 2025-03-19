# Gunakan image dasar untuk Rust
FROM rust:1.81.0 AS rust-build

# Set working directory untuk Rust (risc0-merkle-service)
WORKDIR /app/risc0-merkle-service
COPY ./risc0-merkle-service /app/risc0-merkle-service
RUN cargo build --release

# Gunakan image dasar untuk Go
FROM golang:1.18 AS go-build

# Set working directory untuk Go (main.go)
WORKDIR /app
COPY ./ /app
RUN go build -o main main.go

# Langkah 3: Menjalankan aplikasi di environment ringan
FROM debian:bullseye-slim

# Install dependensi runtime seperti curl dan lib lainnya
RUN apt-get update && apt-get install -y curl

# Salin file aplikasi yang telah dibuild
COPY --from=rust-build /app/risc0-merkle-service/target/release/risc0-merkle-service /usr/local/bin/risc0-merkle-service
COPY --from=go-build /app/main /usr/local/bin/main

# Mengekspos port yang diperlukan oleh kedua server
EXPOSE 8080 8081

# Perintah untuk menjalankan aplikasi
CMD bash -c "risc0-merkle-service & main"
