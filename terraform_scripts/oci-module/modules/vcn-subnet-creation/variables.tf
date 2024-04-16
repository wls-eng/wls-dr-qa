variable "tenancy_ocid" {
  description = "The OCID of the compartment where to create all resources"
  type = string
}

variable "compartment_ocid" {
  description = "The OCID of the compartment where to create all resources"
  type = string
}

variable "AD" {
  description = "The availability domain of the instance. ad1 in PCA X9-2 tenancy"
  type = string
  default = "3"
}

variable "vcn_label" {
  description = "VCN Display Name"
  type = string
  default = "WlsVCN"
}

variable "vcn_cidr" {
  description = "VCN CIDR detail"
  type = string
  default = "10.0.0.0/16"
}

variable "security_list_egress_security_rules_stateless" {
  description = "Describes if the state in Route table should be Stateful or Stateless"
  type = bool
  default = false
}

variable "create_service_gateway" {
  description = "whether to create a service gateway. If set to true, creates a service gateway."
  default     = true
  type        = bool
}
