# terraform-proxmox-download-file

Downloads a file straight into a Proxmox datastore: a boot image (ISO) or a disk image to import as a VM disk. Proxmox fetches the
file from its own network, so nothing goes through the machine that runs Terraform.

## Usage

```hcl
module "iso" {
  source = "git::https://github.com/itlinuxfr/terraform-proxmox-download-file.git?ref=v1.0.0"

  node_name    = "pve-01"
  datastore_id = "local"
  url          = "https://example.com/images/talos.iso"
  file_name    = "talos.iso"
}
```

Safe defaults: HTTPS only, no overwrite of an existing file, TLS verified. The checksum is optional; when set, its length is checked
against the algorithm. See the [`examples/`](examples/) directory for an ISO and for a compressed disk image.

## Upgrading from `terraform-proxmox-upload-iso`
This module is the renamed and rewritten `terraform-proxmox-upload-iso` (GitHub redirects the old URL). The variables changed
(`proxmox_node` is now `node_name`, `proxmox_iso_storage` is `datastore_id`, `proxmox_iso_url` is `url`, and so on). The resource moves from the
deprecated `proxmox_virtual_environment_download_file` to `proxmox_download_file` with a `moved` block, so the file is not downloaded again.
The plan shows `moved from ...` and no destroy. The old module defaulted to `overwrite = true`: the plan also shows an in-place change of
`overwrite` to `false`, the new safe default. Set `overwrite = true` to keep the old behavior. Always run `terraform plan` first.

## Contributing
Read [`AGENTS.md`](AGENTS.md) for conventions and commands, and [`SECURITY.md`](SECURITY.md) for security rules.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 0.100.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 0.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_download_file.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/download_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datastore_id"></a> [datastore\_id](#input\_datastore\_id) | ID of the Proxmox datastore that stores the file (for example local). It must allow the chosen content type. | `string` | n/a | yes |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | Name of the Proxmox node that downloads the file. | `string` | n/a | yes |
| <a name="input_url"></a> [url](#input\_url) | HTTPS URL of the file to download. | `string` | n/a | yes |
| <a name="input_checksum"></a> [checksum](#input\_checksum) | Expected checksum of the downloaded file, in hexadecimal. Null skips the integrity check. | `string` | `null` | no |
| <a name="input_checksum_algorithm"></a> [checksum\_algorithm](#input\_checksum\_algorithm) | Algorithm of the checksum: md5, sha1, sha224, sha256, sha384 or sha512. Only used when checksum is set. | `string` | `"sha256"` | no |
| <a name="input_content_type"></a> [content\_type](#input\_content\_type) | Proxmox content type: iso for a boot image, import for a disk image to import as a VM disk. | `string` | `"iso"` | no |
| <a name="input_decompression_algorithm"></a> [decompression\_algorithm](#input\_decompression\_algorithm) | Decompress the downloaded file with this algorithm: gz, lzo, zst or bz2. Null keeps the file as downloaded. | `string` | `null` | no |
| <a name="input_file_name"></a> [file\_name](#input\_file\_name) | Name of the stored file. Null derives it from the URL. For the iso content type it must end with .iso or .img. | `string` | `null` | no |
| <a name="input_overwrite"></a> [overwrite](#input\_overwrite) | Replace the file when it changes (size changed on the datastore, or new size reported by the URL). False never replaces a file that Terraform manages, which avoids a silent re-download. | `bool` | `false` | no |
| <a name="input_overwrite_unmanaged"></a> [overwrite\_unmanaged](#input\_overwrite\_unmanaged) | Delete and replace a file with the same name that Terraform does not manage. False fails if the file already exists. | `bool` | `false` | no |
| <a name="input_upload_timeout"></a> [upload\_timeout](#input\_upload\_timeout) | Download timeout in seconds. | `number` | `600` | no |
| <a name="input_verify_tls"></a> [verify\_tls](#input\_verify\_tls) | Verify the TLS certificate of the source URL. Disable only for a source with a private certificate authority that Proxmox does not trust. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_content_type"></a> [content\_type](#output\_content\_type) | Proxmox content type of the file. |
| <a name="output_datastore_id"></a> [datastore\_id](#output\_datastore\_id) | ID of the datastore that stores the file. |
| <a name="output_file_name"></a> [file\_name](#output\_file\_name) | Name of the stored file. |
| <a name="output_id"></a> [id](#output\_id) | Volume ID of the file (for example local:iso/talos.iso). Use it as the file\_id of a VM CD-ROM, or to import a disk. |
| <a name="output_node_name"></a> [node\_name](#output\_node\_name) | Name of the node that downloaded the file. |
| <a name="output_size"></a> [size](#output\_size) | Size of the file on the datastore, in bytes. |
<!-- END_TF_DOCS -->
