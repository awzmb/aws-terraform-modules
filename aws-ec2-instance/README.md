## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 5.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | > 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | > 5.0 |
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | > 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.ec2_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.ec2_ssh_public_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_route53_record.record_aaaa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ami.amzn_linux_2023_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_instance_profile.ec2_iam_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_instance.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [cloudinit_config.ec2_cloudinit](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ipv4_address"></a> [associate\_public\_ipv4\_address](#input\_associate\_public\_ipv4\_address) | Associate a public address to the instance (defaults to false). Use this only in ipv4 subnets, else the deployment will fail. | `bool` | `false` | no |
| <a name="input_cloudinit_config"></a> [cloudinit\_config](#input\_cloudinit\_config) | Extra cloudinit config to be passed to the instance | `string` | `"echo \\$(hostname)"` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The ID of the hosted zone under which to place a DNS record for this instance, derived from its name. | `string` | `""` | no |
| <a name="input_iam_profile_name"></a> [iam\_profile\_name](#input\_iam\_profile\_name) | The ARN of the IAM instance profile to be assigned. | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for the instance (defaults to t2.nano). | `string` | `"t2.nano"` | no |
| <a name="input_metadata_endpoint_ipv6"></a> [metadata\_endpoint\_ipv6](#input\_metadata\_endpoint\_ipv6) | Whether the metadata endpoint should be reached via IPv6 or not: 'enabled' or 'disabled' | `string` | `"disabled"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the instance. | `string` | n/a | yes |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | (Optional) Size of the volume in gibibytes (GiB). | `number` | `20` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Public SSH key to use for inbound connections. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID to pair the instance with. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the policies and roles. | `map(string)` | <pre>{<br>  "managedby": "terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the instance. |
| <a name="output_ipv6_addresses"></a> [ipv6\_addresses](#output\_ipv6\_addresses) | IPv6 addresses of the instance |
| <a name="output_primary_network_interface_id"></a> [primary\_network\_interface\_id](#output\_primary\_network\_interface\_id) | ID of the instance's primary network interface. |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | Private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC. |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | Public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC. |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP address assigned to the instance, if applicable. |
