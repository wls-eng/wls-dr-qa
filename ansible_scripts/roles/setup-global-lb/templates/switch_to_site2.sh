#!/bin/bash

#enable port forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -p
sysctl --system

#open ports ohs_http_port and ohs_https_port
firewall-cmd --zone=public --add-port={{ ohs_http_port }}/tcp
firewall-cmd --zone=public --add-port={{ ohs_https_port }}/tcp

firewall-cmd --runtime-to-permanent
systemctl restart firewalld

#view port forwarding rules
iptables -t nat -L

#Delete all Port forwarding rules
iptables -t nat -F

#Route requests on port 7777 to site2_lb_vm_ip:ohs_http_port
iptables -t nat -A PREROUTING -p tcp --dport {{ ohs_http_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_http_port }}

#Route requests on port 7777 to site2_lb_vm_ip:ohs_https_port
iptables -t nat -A PREROUTING -p tcp --dport {{ ohs_https_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_https_port }}

iptables -t nat -A POSTROUTING -j MASQUERADE

#view port forwarding rules
iptables -t nat -L
