# Stage 1: Build untuk Linux
FROM golang:1.23.1 as builder-linux

WORKDIR /app
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -o /usr/local/bin/le-light-node-linux .

# Stage 2: Build untuk Windows
FROM golang:1.23 as builder-windows

WORKDIR /app
COPY . .
RUN GOOS=windows GOARCH=amd64 go build -o /usr/local/bin/le-light-node.exe .

# Stage 3: Final Image untuk Linux
FROM alpine:latest

# Salin binary yang sudah dibangun dari builder-linux
COPY --from=builder-linux /usr/local/bin/le-light-node-linux /usr/local/bin/le-light-node-linux

# Tentukan perintah untuk menjalankan aplikasi Linux sebagai default
CMD ["/usr/local/bin/le-light-node-linux"]

# Stage 4: Final Image untuk Windows (Optional)
# Uncomment bagian ini jika kamu ingin menyalin binary Windows ke dalam image terpisah
# FROM alpine:latest AS final-windows
# COPY --from=builder-windows /usr/local/bin/le-light-node.exe /usr/local/bin/le-light-node.exe
# CMD ["/usr/local/bin/le-light-node.exe"]
