# Download a boot image (ISO) to the "local" datastore of a node.
# In a real project, pin the module source to a tag:
#   source = "git::https://github.com/itlinuxfr/terraform-proxmox-download-file.git?ref=v1.0.0"
# The relative source is used by CI: it tests the code of the current branch.
# The URL comes from the Talos Image Factory: the terraform-talos-image module returns it in iso_url.

terraform {
  required_version = ">= 1.15"
}

module "iso" {
  source = "../../"

  node_name    = "pve-01"
  datastore_id = "local"
  url          = "https://factory.talos.dev/image/SCHEMATIC_ID/v1.14.6/nocloud-amd64.iso"
  file_name    = "talos-v1.14.6-nocloud-amd64.iso"
}

output "iso_id" {
  value = module.iso.id
}
