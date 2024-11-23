#!/bin/bash

function usage()
{
  echo "Usage: $0 <VM_NAME> <STATUS_TO_CHECK>"
  echo "Ex: $0 wlsvm0 <RUNNING>"
  exit 1
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/oci_odx_config.properties

VM_NAME="$1"
STATUS_TO_CHECK="$2"

if [ -z "$VM_NAME" ];
then
 echo "VM name not provided"
 usage
fi

if [ -z "${STATUS_TO_CHECK}" ];
then
 echo "STATUS TO CHECK not provided"
 usage
fi

echo "VM_NAME          : $VM_NAME"
echo "STATUS_TO_CHECK  : $STATUS_TO_CHECK"

echo "Checking VM Instance Lifecycle State for $VM_NAME"
INSTANCE_STATE=$(oci compute instance get --instance-id ${!VM_NAME} --query 'data."lifecycle-state"' --raw-output --profile $profile)
echo "VM Instance Lifecycle State: $INSTANCE_STATE"

if [ "$INSTANCE_STATE" == "$STATUS_TO_CHECK" ];
then
  exit 0
else
  echo "VM Instance Life Cycle Status not same as expected"
  exit 1
fi

