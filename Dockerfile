FROM alpine:3.3

ENV GOPATH /goapp
ENV GOBIN /goapp/bin

RUN mkdir -p /goapp/bin && \
    apk add --no-cache git go && \
    git clone https://github.com/zachlatta/sshtron.git sshtron-src && \
    cd sshtron-src && go get && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo && \
    mv ./sshtron-src /sshtron && \
    rm -rf /sshtron-src && rm -rf /goapp && \
    apk del git go

RUN apk add --no-cache openssh && \
    ssh-keygen -t rsa -f id_rsa -N '' && chown nobody:nobody id_rsa && \
    apk del openssh

USER nobody

EXPOSE 2022 3000

ENTRYPOINT ["/sshtron"]
