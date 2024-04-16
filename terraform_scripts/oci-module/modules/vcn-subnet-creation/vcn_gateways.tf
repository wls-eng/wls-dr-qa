#Internet Gateway for Public/Default Subnet's Route table
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name = "Internet Gateway-${var.vcn_label}"
  vcn_id = oci_core_vcn.vcn.id
}

#Service Gateway for Private Subnet's Route table
resource "oci_core_service_gateway" "sgw" {
  compartment_id = var.compartment_ocid
  display_name = "Service Gateway-${var.vcn_label}"
  vcn_id = oci_core_vcn.vcn.id
  services {
    service_id = lookup(data.oci_core_services.all_oci_services[0].services[0], "id")
  }
}

#NAT Gateway for Private Subnet's Route table 
resource "oci_core_nat_gateway" "natgw" {
  compartment_id = var.compartment_ocid
  display_name = "NAT Gateway-${var.vcn_label}"
  vcn_id = oci_core_vcn.vcn.id
}

#Private Subnet Route Table
resource "oci_core_route_table" "PrivateRouteTable" {
  compartment_id = var.compartment_ocid
  display_name = "Route Table for Private Subnet-${var.vcn_label}"
  vcn_id = oci_core_vcn.vcn.id

  route_rules {
    destination = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.natgw.id
  }

  route_rules {
    destination = lookup(data.oci_core_services.all_oci_services[0].services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sgw.id
  }
}

