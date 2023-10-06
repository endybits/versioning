FROM alpine:3.10

COPY ./versioning.sh /versioning.sh

ENTRYPOINT ["/versioning.sh"]

