#Create Private Subnet
resource "oci_core_subnet" "private_subnet" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id
  cidr_block = cidrsubnet(var.vcn_cidr, 8, 1)
  display_name = "Private Subnet-${var.vcn_label}"
  dns_label = "${lower(substr("PrivateSubnet${var.vcn_label}", 0, 15))}"
  route_table_id = oci_core_route_table.PrivateRouteTable.id
  security_list_ids = [oci_core_security_list.private_securitylist.id]
  dhcp_options_id = oci_core_default_dhcp_options.defaultdhcp.id
  prohibit_public_ip_on_vnic = true  
}

#Create Public Subnet
resource "oci_core_subnet" "public_subnet" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id
  cidr_block = cidrsubnet(var.vcn_cidr, 8, 0)
  display_name = "Public Subnet-${var.vcn_label}"
  dns_label = "${lower(substr("PublicSubnet${var.vcn_label}", 0, 15))}"
  dhcp_options_id = oci_core_default_dhcp_options.defaultdhcp.id
  route_table_id = oci_core_default_route_table.defaultroutetable.id
  security_list_ids = [oci_core_default_security_list.defaultseclist.id]
}

#Create SecurityList for Private Subnet
resource "oci_core_security_list" "private_securitylist" {
  display_name = "Security List for Private Subnet-${var.vcn_label}"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id

  egress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "10.0.0.0/16"
    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "1"
    source = "0.0.0.0/0"
    
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "1"
    source = "10.0.0.0/16"
    
    icmp_options {
      type = 3
    }
  }
}
