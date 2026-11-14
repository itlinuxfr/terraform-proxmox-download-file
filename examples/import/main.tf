# Download a compressed disk image and import it as a VM disk source.
# The content type "import" needs Proxmox VE 8.4 or later. The file is decompressed on the datastore.

terraform {
  required_version = ">= 1.15"
}

module "disk_image" {
  source = "../../"

  node_name               = "pve-01"
  datastore_id            = "local"
  content_type            = "import"
  url                     = "https://factory.talos.dev/image/SCHEMATIC_ID/v1.14.6/nocloud-amd64.raw.zst"
  file_name               = "talos-v1.14.6-nocloud-amd64.raw"
  decompression_algorithm = "zst"
}

output "disk_image_id" {
  value = module.disk_image.id
}
