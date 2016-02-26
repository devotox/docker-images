# Base image
FROM gliderlabs/registrator

# Install curl
RUN apk update && apk upgrade && \
apk-install curl wget bash tree

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["consul://consul:8500"]