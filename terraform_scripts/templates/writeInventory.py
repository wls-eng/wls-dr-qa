#!/bin/python

import os
import sys
import shutil

vHostCount=sys.argv[1]
vBasicSetup=sys.argv[2]
vInstallJDK=sys.argv[3]
vInstallWLS=sys.argv[4]
vSSHPrivateKeyPath=sys.argv[5]
vPCAEnv=sys.argv[6]
vLoadBalancer=sys.argv[7]
vSecureMode=sys.argv[8]

vBasicSetupForOHS=sys.argv[9]
vInstallJDKForOHS=sys.argv[10]
vInstallOHS=sys.argv[11]
vSetupDomainForOHS=sys.argv[12]
vVMType=sys.argv[13]
vSiteName=sys.argv[14]

if vVMType == "GLB" :
    print ("VM Type is GLB. This script is not to be executed")
    sys.exit()


skipVMIP="10.133.80.1"
cwd = os.getcwd()

#copy site specific inventory list to be reference later when creating global loadbalancer
shutil.copy(cwd + '/../inventory/inv_multiple_host_create',cwd + '/../inventory/'+vSiteName+'_vm_list')

ipdata = open(cwd + '/../inventory/inv_multiple_host_create', 'r')
Lines = ipdata.read().splitlines()

inventory = open(cwd + '/../inventory/inventory.ini', 'w')

totalcount=0
for line in Lines:
    if '[public]' in line or line.strip() == "":
        continue
    elif skipVMIP in line:
        print("skipping vm with ip address "+skipVMIP +" as it cannot be used")
    else:
        totalcount+=1

vmcount=0

for line in Lines:
    if '[public]' in line or line.strip() == "":
        continue
    elif skipVMIP in line:
        print("skipping vm with ip address "+skipVMIP+" as it cannot be used")
        continue
    else:
        vmcount+=1

        inventory.write('[vm'+str(vmcount)+']\n')
        inventory.write(line)
        inventory.write('\n\n')

if totalcount == 0:
  raise Exception("Invalid inventory input")

vms_in_domain_count=totalcount

#vm1 is always used as ohs_vm
if totalcount >= 1:
   inventory.write('[ohs_vm:children]\nvm1\n\n')

#vm1 is always used as admin_vm
if totalcount >= 1:
   inventory.write('[admin_vm:children]\nvm1\n\n')

#if more than 1 vm, then use other vms for setting up managed servers
if totalcount > 1:
   inventory.write('[managed_server_vms:children]\n')

#define managed server vms
x=range(2,totalcount+1)
for i in x:
   inventory.write('vm'+str(i)+'\n')

inventory.write('\n');

#if more than 1 vm, then use other vms for setting up managed servers
if totalcount > 1:
   inventory.write('[wls_vms:children]\n')

#define managed server vms
x=range(2,totalcount+1)
for i in x:
   inventory.write('vm'+str(i)+'\n')

inventory.write('\n');

if totalcount >= 1:
   inventory.write('[all_vms:children]\nadmin_vm\nohs_vm\n')

if totalcount > 1:
   inventory.write('managed_server_vms\n')

inventory.write('\n');

inventory.write('[all:vars]\n')
inventory.write('basic_setup='+vBasicSetup+'\n')
inventory.write('basic_ohs_setup='+vBasicSetupForOHS+'\n')
inventory.write('install_jdk='+vInstallJDK+'\n')
inventory.write('install_jdk_for_ohs='+vInstallJDK+'\n')
inventory.write('install_wls='+vInstallWLS+'\n')
inventory.write('install_ohs='+vInstallOHS+'\n')
inventory.write('display_install_info=true\n')
inventory.write('ansible_ssh_private_key_file='+vSSHPrivateKeyPath+'\n')
inventory.write('ansible_user=opc\n')
inventory.write('pca_env='+vPCAEnv+'\n')
inventory.write('num_vms_in_wls_domain='+str(vms_in_domain_count)+'\n')
inventory.write('secure_mode_enabled='+vSecureMode+'\n')
inventory.write('setup_ohs_domain='+vSetupDomainForOHS)
inventory.close()

#print contents of inventory file generated
with open(cwd + '/../inventory/inventory.ini') as f:
    for line in f:
        print(line.strip())

f.close()

print('===========================================================================')
