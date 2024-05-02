#!/bin/python

import os
import sys

skipVMIP="10.133.80.1"
cwd = os.getcwd()

vVMType=sys.argv[1]

if vVMType == "WLS" :
    print ("VM Type is WLS. This script is not to be executed")
    sys.exit()

ipdata = open(cwd + '/../inventory/inv_multiple_host_create', 'r')
Lines = ipdata.read().splitlines()

glbInventory = open(cwd + '/../inventory/glbInventory.ini', 'w')

totalcount=0
for line in Lines:
    if '[public]' in line or line.strip() == "":
        continue
    elif skipVMIP in line:
        print("skipping vm with ip address "+skipVMIP +" as it cannot be used")
    else:
        totalcount+=1

if totalcount == 0:
  raise Exception("Invalid inventory input. Excpected 1 got 0")

if totalcount > 1:
  raise Exception("Invalid inventory input. Excpected 1 got greather than 1")

vmcount=1

for line in Lines:
    if '[public]' in line or line.strip() == "":
        continue
    elif skipVMIP in line:
        print("skipping vm with ip address "+skipVMIP+" as it cannot be used")
        continue
    else:
        glbInventory.write('[vm'+str(vmcount)+']\n')
        glbInventory.write(line)
        glbInventory.write('\n\n')

#vm1 is always used as ohs_vm
if totalcount == 1:
   glbInventory.write('[loadbalancer_vm:children]\nvm1\n\n')

site1data = open(cwd + '/../inventory/site1_vm_list', 'r')
site1Lines = site1data.read().splitlines()

site1VMCount=0
for site1line in site1Lines:
    if '[public]' in site1line or site1line.strip() == "":
        continue
    elif skipVMIP in site1line:
       print("skipping vm with ip address "+skipVMIP+" as it cannot be used")
       continue
    elif site1VMCount >= 1:
       print("Skippping other VMs in the site1_vm_list")
       continue
    else:
       print("Adding VM "+site1line+"to site1Lb list from site1_vm_list")
       glbInventory.write('\n\n')
       glbInventory.write('[site1_lb_vm]\n')
       glbInventory.write(site1line)
       glbInventory.write('\n\n')
       site1VMCount=site1VMCount+1

site1data.close()

site2data = open(cwd + '/../inventory/site2_vm_list', 'r')
site2Lines = site2data.read().splitlines()

site2VMCount=0
for site2line in site2Lines:
    if '[public]' in site2line or site2line.strip() == "":
        continue
    elif skipVMIP in site2line:
       print("skipping vm with ip address "+skipVMIP+" as it cannot be used")
       continue
    elif site2VMCount >= 1:
       print("Skippping other VMs in the site2_vm_list")
       continue
    else:
       print("Adding VM "+site1line+"to site2Lb list from site2_vm_list")
       glbInventory.write('\n\n')
       glbInventory.write('[site2_lb_vm]\n')
       glbInventory.write(site2line)
       glbInventory.write('\n\n')
       site2VMCount=site2VMCount+1

site2data.close()
glbInventory.close()

#print contents of inventory file generated
with open(cwd + '/../inventory/glbInventory.ini') as f:
    for line in f:
        print(line.strip())

f.close()
