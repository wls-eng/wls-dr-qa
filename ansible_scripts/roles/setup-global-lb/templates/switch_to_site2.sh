#!/bin/bash

sudo iptables -t nat -L -v -n --line-numbers | grep "${site2_lb_vm_ip}"
if [ "$?" == "0" ];
then
    echo "deleting site2 related iptable rules"
    sudo iptables -t nat -D PREROUTING -p tcp --dport {{ohs_http_port}} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ohs_http_port}}
    sudo iptables -t nat -D PREROUTING -p tcp --dport {{ohs_https_port}} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ohs_https_port}}
    sudo iptables -t nat -D PREROUTING -p tcp --dport {{ohs_http_port_for_wls_admin_server}} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_http_port_for_wls_admin_server }}
fi

sudo iptables -t nat -L -v -n --line-numbers | grep "${site1_lb_vm_ip}"
if [ "$?" == "0" ];
then
    echo "deleting site1 related iptable rules"
    sudo iptables -t nat -D PREROUTING -p tcp --dport {{ohs_http_port}} -j DNAT --to-destination {{site1_lb_vm_ip}}:{{ohs_http_port}}
    sudo iptables -t nat -D PREROUTING -p tcp --dport {{ohs_https_port}} -j DNAT --to-destination {{site1_lb_vm_ip}}:{{ohs_https_port}}
    sudo iptables -t nat -D PREROUTING -p tcp --dport {{ohs_http_port_for_wls_admin_server}} -j DNAT --to-destination {{site1_lb_vm_ip}}:{{ ohs_http_port_for_wls_admin_server }}
fi

sudo iptables -t nat -L -v -n --line-numbers | grep "MASQUERADE"
if [ "$?" == "0" ];
then
    echo "Deleting POSTROUTING MASQUERADE rule"
    sudo iptables -t nat -D POSTROUTING -j MASQUERADE
fi

echo "IP Table Rules after Deletion, if any..."
sudo iptables -t nat -L -v -n --line-numbers


echo "Adding new IPTable Rules for Routing to Site1..."
sudo iptables -t nat -A PREROUTING -p tcp --dport {{ohs_http_port}} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ohs_http_port}}
sudo iptables -t nat -A PREROUTING -p tcp --dport {{ohs_https_port}} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ohs_https_port}}
sudo iptables -t nat -A PREROUTING -p tcp --dport {{ohs_http_port_for_wls_admin_server}} -j DNAT --to-destination {{site2_lb_vm_ip}}:{{ ohs_http_port_for_wls_admin_server }}
sudo iptables -t nat -A POSTROUTING -j MASQUERADE

echo "IP Table Rules after Adding new rules to Site1"
sudo iptables -t nat -L -v -n --line-numbers
