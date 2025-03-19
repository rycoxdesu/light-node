# Stage 1: Build untuk Linux
FROM golang:1.18-alpine as builder-linux

WORKDIR /app
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -o /bin/le-light-node-linux .

# Stage 2: Build untuk Windows
FROM golang:1.18-alpine as builder-windows

WORKDIR /app
COPY . .
RUN GOOS=windows GOARCH=amd64 go build -o /bin/le-light-node.exe .

# Stage 3: Final
FROM alpine:latest

# Copy binary yang sudah dibangun
COPY --from=builder-linux /bin/le-light-node-linux /bin/le-light-node-linux
COPY --from=builder-windows /bin/le-light-node.exe /bin/le-light-node.exe

# Tentukan perintah untuk menjalankan aplikasi
CMD ["/bin/le-light-node-linux"]
