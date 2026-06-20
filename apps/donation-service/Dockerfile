# apps/donation-service/Dockerfile

# ---- Stage 1: build ----
FROM golang:1.25.11-alpine3.22 AS builder

RUN apk add --no-cache git ca-certificates tzdata

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY main.go .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s" \
    -o donation-service \
    ./main.go

# ---- Stage 2: runtime ----
FROM alpine:3.22 AS runtime

RUN apk upgrade --no-cache && apk add --no-cache ca-certificates tzdata wget

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder --chown=appuser:appgroup /app/donation-service .

USER appuser

EXPOSE 8082

HEALTHCHECK --interval=15s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:8082/health || exit 1

ENTRYPOINT ["/app/donation-service"]