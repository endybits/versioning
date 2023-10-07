FROM alpine:3.10

RUN apk add --no-cache git grep

COPY ./versioning.sh /versioning.sh

ENTRYPOINT ["/versioning.sh"]