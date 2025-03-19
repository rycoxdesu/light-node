# Gunakan image resmi Golang sebagai base image
FROM golang:1.23 AS builder

# Tentukan direktori kerja dalam kontainer
WORKDIR /app

# Salin seluruh kode sumber ke dalam kontainer
COPY . .

# Buat direktori output bin
RUN mkdir -p bin

# Build binary untuk Linux
RUN GOOS=linux GOARCH=amd64 go build -o bin/le-light-node-linux .

# Build binary untuk Windows
RUN GOOS=windows GOARCH=amd64 go build -o bin/le-light-node.exe .

# Stage kedua: Image final untuk menjalankan aplikasi
FROM alpine:latest

# Salin binary hasil build dari tahap builder
COPY --from=builder /app/bin /app/bin

# Tentukan perintah untuk menjalankan aplikasi Linux sebagai default
CMD ["/app/bin/le-light-node-linux"]
