locals {
  instances_details = [
    // display name, Primary VNIC Public/Private IP for each instance
    for i in oci_core_instance.instance : <<EOT
    ${~i.display_name~}
    Primary-PublicIP: %{if i.public_ip != ""}${i.public_ip~}%{else}N/A%{endif~}
    Primary-PrivateIP: ${i.private_ip~}
    EOT
  ]
}

output "instances_summary" {
  description = "Private and Public IPs for each instance."
  value       = local.instances_details
}

output "instance_id" {
  description = "ocid of created instances. "
  value       = oci_core_instance.instance.*.id
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = oci_core_instance.instance.*.private_ip
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = oci_core_instance.instance.*.public_ip
}
