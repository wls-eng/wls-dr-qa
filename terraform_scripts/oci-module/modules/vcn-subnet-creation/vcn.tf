#Create VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block = var.vcn_cidr
  dns_label = var.vcn_label
  display_name = var.vcn_label
}

resource "oci_core_default_dhcp_options" "defaultdhcp" {
  manage_default_resource_id = oci_core_vcn.vcn.default_dhcp_options_id

  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  options {
    type = "SearchDomain"
    search_domain_names = [ "${lower(var.vcn_label)}.oraclevcn.com" ]
  }
}

resource "oci_core_default_security_list" "defaultseclist" {
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

    egress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "all"
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to SSH port 22"
    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to WebLogic ports 7001, 7002"
    tcp_options {
      max = 7002
      min = 7001
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to WebLogic Managed Server ports 8001 to 8020"
    tcp_options {
      max = 8020
      min = 8001
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    description = "Allow access to WebLogic Managed Server ports 8201 to 8210"
    source_type = "CIDR_BLOCK"
    tcp_options {
      max = 8210
      min = 8201
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to WebLogic Managed Server Channel ports 8501 to 8510"
    tcp_options {
      max = 8510
      min = 8501
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to WebLogic Nodemanager port 5556"
    tcp_options {
      max = 5556
      min = 5556
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to WebLogic Domain-wide Administration port 9002"
    tcp_options {
      max = 9002
      min = 9002
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to WebLogic Managed Server Administration ports 9501 to 9510"
    tcp_options {
      max = 9510
      min = 9501
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to OHS non-secure port 7777"
    tcp_options {
      max = 7777
      min = 7777
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to OHS secure-port 4443"
    tcp_options {
      max = 4443
      min = 4443
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow access to OHS port 8888"
    tcp_options {
      max = 8888
      min = 8888
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "1"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless = var.security_list_egress_security_rules_stateless
    protocol = "1"
    source = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    icmp_options {
      type = 3
    }
  }
}

resource "oci_core_default_route_table" "defaultroutetable" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id

  route_rules {
    destination = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}
