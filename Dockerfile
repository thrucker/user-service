FROM golang:alpine as builder

WORKDIR /app/shippy-service-user

COPY go.mod ./go.mod
COPY go.sum ./go.sum

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-service-user main.go database.go handler.go repository.go token_service.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /app/shippy-service-user/shippy-service-user .

CMD ["./shippy-service-user"]
