#!/bin/bash

function usage()
{
  echo "Usage: $0 <VM_NAME>"
  echo "Ex: $0 wlsvm0"
  exit 1
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/oci_odx_config.properties

VM_NAME="$1"

if [ -z "$VM_NAME" ];
then
 echo "VM name not provided"
 usage
fi

VM_OCID="${!VM_NAME}"

if [ -z "$VM_OCID" ];
then
  echo "VM_OCID not available for VM $VM_NAME. Please check the configuration details and try again"
  exit 1
fi

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

sh $SCRIPT_DIR/check_vm_status.sh $VM_NAME RUNNING
ret=$?

if [ $ret -eq 0 ];
then
  echo "VM $VM_NAME is already RUNNING"
  exit 0
fi

echo "Starting VM $VM_NAME"
oci compute instance action --instance-id ${VM_OCID} --action START --profile $profile

MAX_ATTEMPTS=5
attempt=1
success="false"

while (( attempt <= MAX_ATTEMPTS )); do
  echo "Waiting... $attempt of $MAX_ATTEMPTS..."
  echo "Waiting for 30s for VM to Start"
  sleep 30s

  sh $SCRIPT_DIR/check_vm_status.sh $VM_NAME RUNNING
  ret=$?

  if [ $ret -eq 0 ];
  then
    echo "VM $VM_NAME is successfully STARTED"
    success="true"
    break
  fi

  ((attempt++))
done

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


if [ "${success}" == "true" ];
then
   exit 0
else
   echo "VM $VM_NAME failed to START. Please try again"
   exit 1
fi
