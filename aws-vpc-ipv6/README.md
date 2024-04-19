## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | > 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc-central"></a> [vpc-central](#module\_vpc-central) | terraform-aws-modules/vpc/aws | n/a |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_ecr_vpc_endpoints"></a> [enable\_ecr\_vpc\_endpoints](#input\_enable\_ecr\_vpc\_endpoints) | Enable VPC private link endpoints for ECR. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the vpc. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to create the vpc in. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the vpc and resources. | `map(string)` | <pre>{<br>  "managedby": "terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azs"></a> [azs](#output\_azs) | Availability zones. |
| <a name="output_cidr"></a> [cidr](#output\_cidr) | The CIDR block of the VPC |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | ID of default security group. |
| <a name="output_name"></a> [name](#output\_name) | Name of the VPC. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of private subnets. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of public subnets. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | ARN of the VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC. |
