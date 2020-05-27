# VERSION:
#   VERSION="1.0"
# BUILD:
#   docker build . -t softcatala/sc-static-file-server:$VERSION
# RUN:
#   docker run -v $(pwd)/data:/data --rm --name scStaticFileServer softcatala/sc-static-file-server:$VERSION

FROM golang:1.13-alpine as builder
WORKDIR /src
RUN apk update && apk add --no-cache git && rm -rf /var/cache/apk/*
COPY scStaticFileServer.go .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" \
     -o scStaticFileServer scStaticFileServer.go

FROM scratch
WORKDIR /
COPY --from=builder /src/scStaticFileServer .
VOLUME ["/static", "/templates"]
CMD ["./scStaticFileServer"]
