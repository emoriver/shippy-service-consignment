#build stage
FROM golang:alpine AS builder

#aggiunto --bash perché non gestiva bene il recupero di "protoc-gen-go" 22/3/2020 ra
RUN apk update && apk upgrade && \
    apk add --no-cache git --upgrade bash

#aggiunti per progetto shippy 22/3/2020 ar
RUN GO111MODULE=on \
    go get google.golang.org/grpc \
        github.com/golang/protobuf/protoc-gen-go

RUN mkdir /app
WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-service-consignment

#final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app
COPY --from=builder /app/shippy-service-consignment .

LABEL Name=shippy-service-consignment Version=0.0.1

EXPOSE 50051
