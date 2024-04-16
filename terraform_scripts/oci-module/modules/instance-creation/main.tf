resource "oci_core_instance" "instance" {
  count = var.instance_count
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain -1]["name"]
  compartment_id      = var.compartment_ocid
  shape               = var.instance_shape
  display_name        = "${var.display_name}-${count.index}"

  shape_config {
    ocpus = var.instance_ocpus
    memory_in_gbs = "8"
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "Primary VNIC"
    assign_public_ip = var.assign_public_ip
    assign_private_dns_record = true
    hostname_label = "${var.display_name}${count.index}"
  }

  source_details {
    source_type = "image"
    source_id = var.source_id != "" ? var.source_id : lookup(data.oci_core_images.compute_images.images[0], "id")
    boot_volume_size_in_gbs = "60"
  }

  metadata = {
    ssh_authorized_keys = pathexpand(file(var.ssh_public_key))
  }
}

# Generate inventory file with Public & Private IPs for Python script
resource "local_file" "inventory" {
  content = templatefile("${path.module}/../../../templates/${var.inventory_name}.tpl",
    {
        public_ip_address = oci_core_instance.instance.*.public_ip
    }
  )
  filename = "${path.module}/../../../inventory/${var.inventory_name}"
}

# To make sure all instances are ready to operate
resource "time_sleep" "wait_for_creation" {
  depends_on = [
    oci_core_instance.instance
  ]
  create_duration = "120s"
}

# Create Inventory file for ansible
resource "null_resource" "ansible-exec" {
  depends_on = [
    time_sleep.wait_for_creation
  ]

  provisioner "local-exec" {
    on_failure  = fail
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod 0755 ${path.module}/../../../templates/writeInventory.py; ${path.module}/../../../templates/writeInventory.py ${var.instance_count} ${var.basic_setup} ${var.install_jdk} ${var.install_wls} ${var.ssh_private_key_path} ${var.pca_env} ${var.load_balancer} ${var.secure_mode} ${var.basic_ohs_setup} ${var.install_jdk_for_ohs} ${var.install_ohs} ${var.setup_ohs_domain}"
  }

  /* commenting this block, as the ansible playbook will be executed separately outside of terraform */
  /* If you wish to run it as part of terraform, you can uncomment the block */
  /*
  provisioner "local-exec" {
    working_dir = "${path.module}/../../../../ansible_scripts"
    command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i '${abspath(path.module)}/../../../inventory/inventory.ini' 'create-cluster-domain.yml'"
  }
  */
}
