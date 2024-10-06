# Dockerfile

FROM alpine:latest

# Install iptables, iproute2, and bind-tools (for nslookup)
RUN apk add --no-cache iptables iproute2 bind-tools

# Copy the script that will set up port forwarding
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set default values for environment variables
ENV REMOTE_IP=""
ENV REMOTE_DOMAIN=""
ENV REMOTE_PORT=""
ENV LOCAL_PORT=""
ENV PROTOCOL="udp"

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]
