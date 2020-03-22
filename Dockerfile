#build stage
FROM golang:alpine AS builder
WORKDIR /go/src/app
COPY . .
RUN apk add --no-cache git --upgrade bash
#aggiunti per progetto shippy 22/3/2020 ar
RUN GO111MODULE=on \
    go get google.golang.org/grpc \
        github.com/golang/protobuf/protoc-gen-go
#
RUN go get -d -v ./...
RUN go install -v ./...

#final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/bin/app /app
ENTRYPOINT ./app
LABEL Name=shippy-service-consignment Version=0.0.1
EXPOSE 50051
