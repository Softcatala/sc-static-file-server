# VERSION:
#   VERSION="1.0"
# BUILD:
#   docker build . -t json2file-go:$VERSION
# RUN:
#   docker run -v $(pwd)/data:/data --rm --name json2file-go    \
#              -e JSON2FILE_DIRLIST="test1:123456;test2:" json2file-go:$VERSION


FROM golang:1.13-alpine as builder
WORKDIR /src
RUN apk update && apk add --no-cache git && rm -rf /var/cache/apk/*
COPY scStaticFileServer.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" \
     -o scStaticFileServer scStaticFileServer.go

FROM scratch
WORKDIR /
COPY --from=builder /src/scStaticFileServer .
ENV JSON2FILE_BASEDIR /data
VOLUME ["/static", "templates"]
CMD ["./scStaticFileServer"]
