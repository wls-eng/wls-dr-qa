[vm1]
public_ip_1

[vm2]
public_ip_2

[vm3]
public_ip_3

[admin_vm:children]
vm1

[managed_server_vms:children]
vm1
vm2
vm3

[all_vms:children]
admin_vm
managed_server_vms

[all:vars]
basic_setup=basic-setup
install_jdk=inst-jdk
install_wls=inst-wls
display_install_info=true
ansible_ssh_private_key_file=private-key-path
ansible_user=opc
pca_env=pca-env
