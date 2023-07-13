FROM golang:1.20 AS build

RUN mkdir /build
COPY go.mod main.go /build/
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -C /build -o ./goapp .

FROM alpine:latest

RUN mkdir /app
COPY --from=build /build/goapp /app/
COPY html /app/html

WORKDIR /app
EXPOSE 8080 9090
CMD [ "/app/goapp" ]
