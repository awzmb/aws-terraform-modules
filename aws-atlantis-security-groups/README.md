## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | > 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atlassian_ip_ranges_prefix_list"></a> [atlassian\_ip\_ranges\_prefix\_list](#module\_atlassian\_ip\_ranges\_prefix\_list) | git::git@bitbucket.org:metamorphant/aws-ec2-atlassian-prefix-list.git//. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.atlantis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.atlassian_alb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.atlassian_alb_sg_egress_rule_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.atlassian_alb_sg_egress_rule_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.atlassian_alb_sg_ipv4_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.atlassian_alb_sg_ipv6_ingress_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_port"></a> [atlantis\_port](#input\_atlantis\_port) | Atlantis port to enable incoming traffic from Bitbucket Cloud to. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the key and other resources. | `map(string)` | <pre>{<br>  "managedby": "terraform"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to assign the security groups with (use the same VPC as the Atlantis container is associated with). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_security_group_arns"></a> [alb\_security\_group\_arns](#output\_alb\_security\_group\_arns) | n/a |
| <a name="output_alb_security_group_ids"></a> [alb\_security\_group\_ids](#output\_alb\_security\_group\_ids) | n/a |
| <a name="output_atlantis_security_group_arns"></a> [atlantis\_security\_group\_arns](#output\_atlantis\_security\_group\_arns) | n/a |
| <a name="output_atlantis_security_group_ids"></a> [atlantis\_security\_group\_ids](#output\_atlantis\_security\_group\_ids) | n/a |
