variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type = string
}

variable "compartment_ocid" {
  description = "The OCID of the compartment where to create all resources"
  type = string
}

variable "user_ocid" {
  description = "User OCID"
  type = string
}

variable "fingerprint" {
  description = "Fingerprint of the SSH key to login"
  type = string
}

variable "region" {
  description = "region provides details about a specific OCI region"
  type = string
}

variable "ssh_public_key" {
  description = "Public SSH keys to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
  type = string
}

variable "private_key_path" {
  description = "Private key file path for authenticating the user against the Tenancy"
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
  default = "wls-vm"
}

variable "basic_setup" {
  description = "True/False to execute the ansible script for setting up basic setup before installations"
  type = bool
  default = true
}

variable "install_jdk" {
  description = "True/False to execute the ansible script for installing JDK"
  type = bool
  default = true
}

variable "install_wls" {
  description = "True/False to execute the ansible script for installing WLS"
  type = bool
  default = true
}

variable "pca_env" {
  description = "True/false to execute the ansible script based on pca-x9 or odx environment"
  type = bool
  default=false
}

variable "load_balancer" {
  description = "nginx/ohs loadbalancer type"
  type = string
  default="ohs"
}

variable "source_id" {
  description = "Source Image information used during Instance creation"
  type = string
}

variable "secure_mode" {
  description = "True/False to execute the ansible script for creating secure or insecure WebLogic domain. True by default"
  type = bool
  default = true
}

variable "vcn_label" {
  description = "Define label for VCN being created"
  type = string
  default = "wlsVCN"
}
