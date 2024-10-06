#!/bin/sh

# Use environment variables
REMOTE_IP="${REMOTE_IP:-}"
REMOTE_DOMAIN="${REMOTE_DOMAIN:-}"
REMOTE_PORT="${REMOTE_PORT:-}"
LOCAL_PORT="${LOCAL_PORT:-}"
PROTOCOL="${PROTOCOL:-udp}"  # Default to UDP

# Check if both REMOTE_PORT and LOCAL_PORT are provided
if [ -z "$REMOTE_PORT" ] || [ -z "$LOCAL_PORT" ]; then
  echo "Error: Both REMOTE_PORT and LOCAL_PORT must be specified."
  exit 1
fi

# Resolve domain to IP if REMOTE_IP is not set
if [ -z "$REMOTE_IP" ] && [ -n "$REMOTE_DOMAIN" ]; then
  REMOTE_IP=$(getent hosts "$REMOTE_DOMAIN" | awk '{ print $1 }')
  if [ -z "$REMOTE_IP" ]; then
    echo "Error: Unable to resolve domain $REMOTE_DOMAIN"
    exit 1
  fi
fi

# Check if REMOTE_IP is still empty
if [ -z "$REMOTE_IP" ]; then
  echo "Error: No remote IP or domain provided."
  exit 1
fi

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Set protocol-specific rules
if [ "$PROTOCOL" = "udp" ]; then
  iptables -t nat -A PREROUTING -p udp --dport ${LOCAL_PORT} -j DNAT --to-destination ${REMOTE_IP}:${REMOTE_PORT}
else
  iptables -t nat -A PREROUTING -p tcp --dport ${LOCAL_PORT} -j DNAT --to-destination ${REMOTE_IP}:${REMOTE_PORT}
fi

iptables -t nat -A POSTROUTING -j MASQUERADE

# Keep the container running
tail -f /dev/null
