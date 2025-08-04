# Stage 1 - Build
FROM golang:1.22.5 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Build with optimizations and static linking
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o main .

# Stage 2 - Minimal final image
FROM gcr.io/distroless/static

WORKDIR /

COPY --from=builder /app/main /
COPY --from=builder /app/static /static

EXPOSE 8080

CMD ["/main"]
