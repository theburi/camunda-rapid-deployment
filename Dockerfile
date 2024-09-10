# Use an official Alpine image as the base
FROM alpine:3.17

# Set environment variables for Zeebe version
ENV ZEEBE_VERSION=8.2.5

# Install dependencies and zbctl
RUN apk add --no-cache curl bash \
    && curl -L https://github.com/camunda/zeebe/releases/download/${ZEEBE_VERSION}/zbctl-${ZEEBE_VERSION}-linux-amd64.tar.gz \
    | tar -xz -C /usr/local/bin \
    && mv /usr/local/bin/zbctl-${ZEEBE_VERSION}-linux-amd64 /usr/local/bin/zbctl \
    && chmod +x /usr/local/bin/zbctl

# Set default Zeebe address as environment variable
ENV ZEEBE_ADDRESS=zeebe-gateway.camunda.svc.cluster.local:26500

# Command to run zbctl status with the specified address
CMD ["zbctl", "--address", "$ZEEBE_ADDRESS", "status"]