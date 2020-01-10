ARG buildImage="golang:alpine"
FROM ${buildImage} as builder

RUN apk add --no-cache protobuf git
RUN go get -u github.com/micro/protobuf/proto
RUN go get -u github.com/micro/protobuf/protoc-gen-go

WORKDIR /app/shippy-service-user

COPY go.mod ./go.mod
COPY go.sum ./go.sum

RUN go mod download

COPY . .

RUN go generate
RUN CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o shippy-service-user main.go database.go handler.go repository.go token_service.go

FROM alpine:latest as main

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /app/shippy-service-user/shippy-service-user .

CMD ["./shippy-service-user"]

FROM builder as obj-cache

COPY --from=builder /root/.cache /root/.cache
