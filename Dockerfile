FROM golang:1.13.8-alpine 

WORKDIR /workspaces/shippy-service-consignment
COPY . .

RUN apk add --no-cache ca-certificates musl-dev gcc file git nano curl \
    && apk update \
    && apk upgrade \
    && rm -rf /var/cache/apk/*

RUN GO111MODULE=on \
    && go get golang.org/x/tools/gopls \
    && go get github.com/go-delve/delve/cmd/dlv \    
    && go get google.golang.org/grpc \
    && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip \
    && unzip protoc-3.11.4-linux-x86_64.zip \
    && go get github.com/golang/protobuf/protoc-gen-go \
    && go get github.com/mdempsky/gocode \
    && go get github.com/uudashr/gopkgs/v2/cmd/gopkgs \
    && go get github.com/ramya-rao-a/go-outline \
    && go get github.com/stamblerre/gocode \
    && go get github.com/rogpeppe/godef \
    && go get github.com/sqs/goreturns \
    && go get golang.org/x/lint/golint

#RUN go install -v ./...
RUN go build -o main main.go

EXPOSE 2345 50051

CMD ["./main"]