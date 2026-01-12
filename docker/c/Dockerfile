# C Judge Container
FROM gcc:12-alpine

RUN addgroup -S judge && adduser -S judge -G judge

WORKDIR /sandbox

RUN apk add --no-cache tini

COPY execute.sh /usr/local/bin/execute.sh
RUN chmod +x /usr/local/bin/execute.sh

USER judge

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/execute.sh"]
