# Base image
FROM gliderlabs/registrator

# Install dependencies
RUN apk update && apk upgrade && \
apk add curl wget bash tree && \
rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["consul://consul:8500"]