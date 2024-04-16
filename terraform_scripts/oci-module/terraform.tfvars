#To specify tenancy ocid, compartment ocid, user ocid, fingerprint, private keypath, region
#set and export the following environment variables
#TF_VAR_tenancy_ocid
#TF_VAR_compartment_ocid
#TF_VAR_user_ocid
#TF_VAR_fingerprint
#TF_VAR_private_key_path
#TF_VAR_region
#To specify the image source, export TF_VAR_source_id environment variable

#Authentication Details
ssh_public_key = "~/.ssh/id_rsa.pub"
ssh_private_key_path = "~/.ssh/id_rsa"

#Instance Name will be set dynamically
#display_name = "wls-vm"

#specify these values using TF_VAR_basic_setup, TF_VAR_install_jdk and TF_VAR_install_wls environment variables
# - basic_setup will create 'oracle' user & grp and necessary jdk & wls install directories
# - install_jdk will install jdk
# - install_wls will install weblogic server
#basic_setup = true
#install_jdk = true
#install_wls = true

#specify loadbalancer as nginx/ohs
#load_balancer = "nginx"

#specify VM Image source id using TF_VAR_source_id environment variable
#source_id = ""

#This terraform.tfvars is specifically for oci and hence pca_env is set to false
pca_env = false

#specify secure_domain=true/false using TF_VAR_secure_domain environment variable
#based on which Secure/Insecure WebLogic Domain is created
#By default secure_mode is set to true
#secure_mode=true
