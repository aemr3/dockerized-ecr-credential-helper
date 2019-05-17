FROM alpine:3.7

RUN apk add --no-cache ca-certificates
RUN apk --no-cache add --virtual build-dependencies gcc g++ musl-dev go git && \
    export GOPATH=/go && \
    export PATH=$GOPATH/bin:$PATH && \
    mkdir $GOPATH && \
    chmod -R 777 $GOPATH && \
    APP_REPO=github.com/awslabs/amazon-ecr-credential-helper && \
    git clone https://$APP_REPO $GOPATH/src/$APP_REPO && \
    cd $GOPATH/src/$APP_REPO && \
    git checkout $APP_VERSION && \
    GOOS=linux CGO_ENABLED=0 go build -installsuffix cgo -a -ldflags '-s -w' -o /usr/bin/docker-credential-ecr-login ./ecr-login/cli/docker-credential-ecr-login && \
    apk del --purge -r build-dependencies && \
    rm -rf /go

FROM gcr.io/cloud-builders/docker

COPY --from=0  /usr/bin/docker-credential-ecr-login /usr/bin/ecr-login
COPY config.json /etc/docker-config.json
