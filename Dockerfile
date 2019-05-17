FROM ubuntu:xenial

RUN apt-get update -y && apt-get install -y wget git && \
  wget -q https://dl.google.com/go/go1.12.2.linux-amd64.tar.gz && \
  tar -xzf go1.12.2.linux-amd64.tar.gz && \
  rm -f go1.12.2.linux-amd64.tar.gz && \
  mv /go /usr/local && \
  export GOPATH=/go && \
  export GOROOT=/usr/local/go && \
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH && \
  mkdir $GOPATH && \
  go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

FROM gcr.io/cloud-builders/docker

COPY --from=0 /go/bin/docker-credential-ecr-login /usr/bin/docker-credential-ecr-login
COPY config.json /etc/docker-config.json
