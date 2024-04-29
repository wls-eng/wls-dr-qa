############################################
# Instance Creation
############################################
module "instance-creation" {
  source                = "./modules/instance-creation"
  tenancy_ocid          = "${var.tenancy_ocid}"
  ssh_public_key  	= "${var.ssh_public_key}"
  compartment_ocid	= "${var.compartment_ocid}"
  ssh_private_key_path	= "${var.ssh_private_key_path}"
  instance_count	= "${var.instance_count}"
  display_name		= "${var.display_name}"
  basic_setup		= "${var.basic_setup}"
  install_jdk		= "${var.install_jdk}"
  install_wls           = "${var.install_wls}"
  pca_env               = "${var.pca_env}"
  load_balancer         = "${var.load_balancer}"
  source_id             = "${var.source_id}"
  secure_mode           = "${var.secure_mode}"
  subnet_id             = "${module.vcn-subnet-creation.public_subnet_id}"
}

############################################
# VCN - Subnet Creation
############################################
module "vcn-subnet-creation" {
  source                = "./modules/vcn-subnet-creation"
  compartment_ocid      = "${var.compartment_ocid}"
  tenancy_ocid          = "${var.tenancy_ocid}"
  vcn_label             = "${var.vcn_label}"
}
