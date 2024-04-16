# Subnet details
output "public_subnet_id" {
  value = "${oci_core_subnet.public_subnet.id}"
}

# VCN Details
output "vcn_id" {
  value = "${oci_core_vcn.vcn.id}"
}
