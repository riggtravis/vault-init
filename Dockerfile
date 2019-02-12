FROM golang:1.11.5-alpine AS builder
RUN apk --no-cache add ca-certificates git
WORKDIR /src

RUN go version
ENV SRC_DIR=/go/src/vault-init
WORKDIR $SRC_DIR
COPY . .
RUN go install
RUN CGO_ENABLE=0 GOOS=linux go build -o vault-init -v .

ENV GIT_SSL_NO_VERIFY=1

FROM alpine:3.9
WORKDIR /root/
COPY --from=0 $SRC_DIR .
CMD ["./vault-init"]

LABEL maintainer="Travis Rigg"
LABEL maintainer.email="rigg.travis@gmail.com"
LABEL description="A port of Seth Vargo's vault-init for AWS"