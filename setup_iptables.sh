#!/bin/bash

# Default policy to drop all incoming connections.
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Read the file with the IP ranges.
while IFS= read -r ip_range
do
  # Allow traffic from the current IP range.
  iptables -A INPUT -s "$ip_range" -j ACCEPT
done < "$1"

# Allow all local traffic.
iptables -A INPUT -s 127.0.0.1 -j ACCEPT

# Allow all outgoing connections.
iptables -P OUTPUT ACCEPT