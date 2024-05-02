variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type = string
}

variable "compartment_ocid" {
  description = "The OCID of the compartment where to create all resources"
  type = string
}

variable "ssh_public_key" {
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
  type = string
}

variable "ssh_private_key_path" {
  description = "Private SSH keys path for the Public SSH keys included in the ~/.ssh/authorized_keys file for the default user on the instance."
  type = string
}

variable "instance_count" {
  description = "Number of instances to provision"
  type = string
}

variable "display_name" {
  description = "A user-friendly name for the instance. it's changeable."
  type = string
}

variable "basic_setup" {
  description = "True/False to execute the ansible script for setting up basic setup before installations"
  type = bool
}

variable "install_jdk" {
  description = "True/False to execute the ansible script for installing JDK"
  type = bool
}

variable "install_wls" {
  description = "True/False to execute the ansible script for installing WLS"
  type = bool
}

variable "pca_env" {
  description = "True/False to exee for pca tenancy. False for OCI tenancy."
  type = bool
  default = false
}

variable "load_balancer" {
  description = "Select the Load balancer from ngnix/OHS"
  type = string
  default="nginx"
}

variable "availability_domain" {
  description = "The availability domain of the instance."
  type = string
  default = "1"
}

variable "instance_shape" {
  description = "The shape of an instance."
  type = string
  default = "VM.Standard.E4.Flex"
}

variable "instance_ocpus" {
  description = "The Number of cpu's for an instance."
  type = string
  default = "1"
}

variable "subnet_id" {
  description = "The unique identifiers (OCIDs) of the subnet in which the instance primary VNICs are created."
  type = string
}

variable "inventory_name" {
  description = "Name of the inventory file that is used by Ansible"
  type = string
  default = "inv_multiple_host_create"
}

variable "assign_public_ip" {
  description = "Whether to create a Public IP to attach to primary vnic"
  type = bool
  default = true
}

#OS Image
variable "image_operating_system" {
  description = "Name of the Operating System"
  type = string
  default = "Oracle Linux"
}

#OS Version
variable "image_operating_system_version" {
  description = "Operating system version"
  type = string
  default = "7.9"
}

variable "source_id" {
  description = ""
  type = string
}

variable "secure_mode" {
  description = "True/false based on which secure/insecure WebLogic Domain is created. True by default"
  type = bool
  default=true
}

variable "basic_ohs_setup" {
  description = "True/false based on which basic utilities require for OHS setup will be installed. True by default"
  type = bool
  default=true
}

variable "install_jdk_for_ohs" {
  description = "True/false based on which JDK specific for OHS setup will be installed. True by default"
  type = bool
  default=true
}

variable "install_ohs" {
  description = "True/false based on which OHS installation will take place. True by default"
  type = bool
  default=true
}

variable "setup_ohs_domain" {
  description = "True/false based on which OHS Standalone Domain is created. True by default"
  type = bool
  default=true
}

variable "vm_type" {
  description = "vm type indicating if the vm will host WLS or Global Loadbalancer"
  type = string
  default = "WLS"
}

variable "site_name" {
  description = "site name of the HA-DA site being created"
  type = string
  default = "site1"
}
