[vm1]
public_ip_1

[vm2]
public_ip_2

[vm3]
public_ip_3

[test_vm]
public_ip_4

[all_vms:children]
test_vm
domain_vms

[domain_vms:children]
vm1
vm2
vm3

[all:vars]
basic_setup=basic-setup
install_jdk=inst-jdk
install_wls=inst-wls
display_install_info=true
ansible_ssh_private_key_file=private-key-path
ansible_user=opc

num_vms_in_wls_domain=host-count
pca_env=pca-env
loadbalancer=load-balancer

