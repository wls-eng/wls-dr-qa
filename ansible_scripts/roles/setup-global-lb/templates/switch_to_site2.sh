#!/bin/bash

#enable port forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -p
sysctl --system

#Flush all IP Table rules
iptables -w -F

#Route requests on port 7777 to site2_lb_vm_ip:ohs_http_port
iptables -w -t nat -A PREROUTING -p tcp --dport {{ ohs_http_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_http_port }}

#Route requests on port 7777 to site2_lb_vm_ip:ohs_https_port
iptables -w -t nat -A PREROUTING -p tcp --dport {{ ohs_https_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_https_port }}

iptables -w -t nat -A POSTROUTING -j MASQUERADE

#view port forwarding rules
iptables -t nat -L
