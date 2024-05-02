#!/bin/bash

#view port forwarding rules
iptables -t nat -L

#Delete all Port forwarding rules
iptables -t nat -F

#Route requests on port 7777 to 129.146.176.71:7777
iptables -t nat -A PREROUTING -p tcp --dport {{ ohs_http_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_http_port }}

#Route requests on port 7777 to 129.146.176.71:4443
iptables -t nat -A PREROUTING -p tcp --dport {{ ohs_https_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_https_port }}

iptables -t nat -A POSTROUTING -j MASQUERADE

#view port forwarding rules
iptables -t nat -L
