#Gets the list of availability domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

#Gets alist of supported images based on compartment, shape, OS
data "oci_core_images" "compute_images" {
  compartment_id = var.compartment_ocid
  operating_system = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape = var.instance_shape
  sort_by = "TIMECREATED"
  sort_order = "DESC"
}

