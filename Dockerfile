FROM golang:1.5-wheezy

ENV PROJ_NAME bitrise

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl git mercurial rsync ruby

# From the official Golang Dockerfile
#  https://github.com/docker-library/golang/blob/master/1.4/Dockerfile
RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p /go/src/github.com/bitrise-io/$PROJ_NAME
COPY . /go/src/github.com/bitrise-io/$PROJ_NAME

WORKDIR /go/src/github.com/bitrise-io/$PROJ_NAME
# godep
RUN go get -u github.com/tools/godep
RUN godep restore
# install
RUN go install

# setup (downloads envman & stepman)
RUN bitrise setup --minimal

CMD bitrise --version
