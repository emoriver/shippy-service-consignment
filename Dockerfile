#build stage
FROM golang:1.13-alpine AS builder

RUN apk --no-cache add ca-certificates git 

WORKDIR /go/src/shippy-service-consignment
COPY . .

RUN apk add --no-cache git 

#RUN go get -d -v ./...
RUN go get -d -v google.golang.org/grpc \
    && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip \
    && unzip protoc-3.11.4-linux-x86_64.zip \
    && go get -d -v github.com/golang/protobuf/protoc-gen-go

#RUN go install -v ./...
RUN go install -v main.go

#final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates

COPY --from=builder /go/bin/shippy-service-consignment /shippy-service-consignment
ENTRYPOINT ./shippy-service-consignment

LABEL Name=shippy-service-consignment Version=0.0.1
EXPOSE 50001
