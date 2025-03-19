# Gunakan image Go sebagai base image
FROM golang:1.18-alpine as builder

# Tentukan direktori kerja dalam container
WORKDIR /app

# Salin semua file dari direktori lokal ke dalam container
COPY . .

# Build aplikasi Go
RUN go build -o /bin/le-light-node .

# Gunakan image lebih kecil untuk menjalankan aplikasi
FROM alpine:latest

# Salin binary yang sudah dibangun dari stage sebelumnya
COPY --from=builder /bin/le-light-node /bin/le-light-node

# Tentukan perintah untuk menjalankan aplikasi
CMD ["/bin/le-light-node"]
