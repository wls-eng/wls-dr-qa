#!/bin/bash

#enable port forwarding
sysctl -w net.ipv4.ip_forward=1
sysctl -p
sysctl --system

echo "*************************************************************************"

echo "IP Table rules before switching to site2"
#view port forwarding rules
iptables -t nat -L -v --line-numbers

iptables -w -t nat -D PREROUTING -p tcp --dport {{ ohs_http_port }} -j DNAT --to-destination {{site1_lb_vm_ip}}:{{ ohs_http_port }}
iptables -w -t nat -D PREROUTING -p tcp --dport {{ ohs_https_port }} -j DNAT --to-destination {{site1_lb_vm_ip}}:{{ ohs_https_port }}
iptables -w -t nat -D PREROUTING -p tcp --dport {{ ohs_http_port_for_wls_admin_server }} -j DNAT --to-destination {{site1_lb_vm_ip}}:{{ ohs_http_port_for_wls_admin_server }}

iptables -w -t nat -D POSTROUTING -j MASQUERADE


iptables -w -t nat -A PREROUTING -p tcp --dport {{ ohs_http_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_http_port }}
iptables -w -t nat -A PREROUTING -p tcp --dport {{ ohs_https_port }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_https_port }}
iptables -w -t nat -A PREROUTING -p tcp --dport {{ ohs_http_port_for_wls_admin_server }} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_http_port_for_wls_admin_server }}

iptables -w -t nat -A POSTROUTING -j MASQUERADE

echo "*************************************************************************"

echo "IP Table rules after switching to site2"
#view port forwarding rules
iptables -t nat -L -v --line-numbers
