## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | > 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | > 3.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_managed_prefix_list.ipv4_prefix_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list) | resource |
| [aws_ec2_managed_prefix_list.ipv6_prefix_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_managed_prefix_list) | resource |
| [http_http.atlassian_ips](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the repository. | `map(string)` | <pre>{<br>  "managedby": "terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipv4_prefix_list_arn"></a> [ipv4\_prefix\_list\_arn](#output\_ipv4\_prefix\_list\_arn) | ID of the ipv4 prefix list. |
| <a name="output_ipv4_prefix_list_id"></a> [ipv4\_prefix\_list\_id](#output\_ipv4\_prefix\_list\_id) | ARN of the ipv4 prefix list. |
| <a name="output_ipv6_prefix_list_arn"></a> [ipv6\_prefix\_list\_arn](#output\_ipv6\_prefix\_list\_arn) | ID of the ipv6 prefix list. |
| <a name="output_ipv6_prefix_list_id"></a> [ipv6\_prefix\_list\_id](#output\_ipv6\_prefix\_list\_id) | ARN of the ipv6 prefix list. |
