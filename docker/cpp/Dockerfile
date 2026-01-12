# C++ Judge Container
FROM gcc:12-alpine

# Create non-root user
RUN addgroup -S judge && adduser -S judge -G judge

WORKDIR /sandbox

# Install essential packages
RUN apk add --no-cache tini

# Copy execution script
COPY execute.sh /usr/local/bin/execute.sh
RUN chmod +x /usr/local/bin/execute.sh

# Resource limits
# CPU: 1 core
# Memory: 256MB
# Timeout: 5 seconds (includes compilation)

USER judge

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/execute.sh"]
