WLS automation using Terraform & Ansible - Following tasks are acheived using this automation project

	1) Instance provision in PCA X9-2
	2) Installation of JDK & WLS
	3) Cluster domain setup
	4) Test code setup

Below are the Prerequisite tasks that needs to be taken care before initiating the process.


Use terraform.tfvars to update the values,if any, before proceeding for Instance Provision

	- Tenancy_ocid
	- user_ocid
	- ssh_public_key
	- private_key_path
	- ssh_private_key_path
	- compartment_ocid
	- region - default 'scasg01'
	- fingerprint
	- instance_count - default & minimum - '4'
	- display_name
	- source_id - default 'Oracle Linux Image 7.9'
	- basic_setup - default 'true'
	- install_jdk - default 'true'
	- install_wls - default 'true'

Please download the respective jdk & wls installers in

	- ansible_scripts/role/install-jdk/files - if install_jdk set to 'true' in terraform.tfvars
	- ansible_scripts/role/install-wls/files - if install_wls set to 'true' in terraform.tfvars
Note:- 
1) Downloading of installers step can be ignored if the install_jdk & install_wls values are  set to 'false'

2) Inventory template located at 'terraform_scripts/templates/inv_domain_create.tpl' needs to be updated if the instance_count is more than default '4'. 
Currently configured with vm1,vm2,vm3 with 'testvm' as fixed. 
If the count is more than '4', please update the template with vm4 and so on depending on the number of count.

Export the below variables before execution of terraform scripts. Mandatory in PCA X9-2 tenancy

	- export https_proxy=http://www.proxy.com:80
	- export HTTPS_PROXY=http://www.proxy.com:80
	- export http_proxy=http://www.proxy.com:80
	- export HTTP_PROXY=http://www.proxy.com:80
	- export no_proxy=.us.oracle.com
	- export TF_VAR_domain_name_override=us.oracle.com
	- export custom_cert_location=~/.oci/PCA.cert.pem

	- Update the below values in /etc/hosts
	  - 10.134.199.8    identity.scasg01.us.oracle.com
	  - 10.134.199.8    iaas.scasg01.us.oracle.com

Commands to be run from 'terraform_scripts/terraform-module

	1) terraform init
	2) terraform validate
	3) terraform apply --var-file=terraform.tfvars
