#!/bin/bash

echo "enable port fowarding"
sysctl -w net.ipv4.ip_forward=1
sysctl -p
sysctl --system

echo "listing existing ip table NAT rules"
iptables -t nat -L -v -n --line-numbers

echo "creating directory for saving existing iptable rules"
mkdir -p /etc/iptables

echo "saving iptable rules to /etc/iptables/existing_rules.v4"
iptables-save > /etc/iptables/existing_rules.v4

#Flush all IP Table rules
echo "Full all iptable rules"
iptables -w -F

