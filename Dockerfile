FROM golang:1.13.8-alpine 

WORKDIR /workspaces/shippy-service-consignment
COPY . .

RUN apk add --no-cache ca-certificates musl-dev gcc file git nano curl \
    && apk update \
    && apk upgrade \
    && rm -rf /var/cache/apk/*

RUN GO111MODULE=on \
    && go get github.com/go-delve/delve/cmd/dlv \    
    && go get -u google.golang.org/grpc \
    && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip \
    && unzip protoc-3.11.4-linux-x86_64.zip \
    && rm -r protoc-3.11.4-linux-x86_64.zip \
    && go get -u github.com/golang/protobuf/protoc-gen-go

RUN go build -o main main.go

CMD ["./main"]