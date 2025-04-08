FROM golang:1.24.2-alpine3.21 as builder

RUN apk update && apk upgrade && \
    apk add --no-cache bash build-base

WORKDIR /opt/transact

# to reduce docker build time download dependency first before building
COPY go.mod .
COPY go.sum .
RUN go mod download

# build
COPY . .

ARG GOARCH
RUN GOOS=linux GOARCH=$GOARCH CGO_ENABLED=0 go build -tags build -o /usr/local/bin/transact main.go

FROM alpine:3.21.3
LABEL maintainer="saravanan_senior_devops"

ENV USER_UID=1001

RUN adduser -D -u ${USER_UID} transactuser

# # install operator binary
COPY --from=builder /usr/local/bin/transact /usr/local/bin/transact
COPY --from=builder /opt/transact/config ./config
COPY --from=builder /opt/transact/db ./db

ENTRYPOINT ["/usr/local/bin/transact"]
