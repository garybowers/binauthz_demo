FROM golang:1.17.7 AS build
RUN mkdir /go/src/demo
WORKDIR /go/src/demo

ADD . ./

RUN go mod init
RUN go build -o demo


FROM debian:11-slim

WORKDIR /
COPY --from=build /go/src/demo/demo /
EXPOSE 8080
CMD ["/demo"]
