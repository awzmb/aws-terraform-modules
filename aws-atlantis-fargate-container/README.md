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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | git::git@bitbucket.org:metamorphant/aws-elb-alb.git//. | n/a |
| <a name="module_custom_container_definition"></a> [custom\_container\_definition](#module\_custom\_container\_definition) | github.com/cloudposse/terraform-aws-ecs-container-definition//. | n/a |
| <a name="module_security_groups"></a> [security\_groups](#module\_security\_groups) | git::git@bitbucket.org:metamorphant/aws-atlantis-security-groups.git//. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [http_http.bitbucket_ips](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_bitbucket_base_url"></a> [atlantis\_bitbucket\_base\_url](#input\_atlantis\_bitbucket\_base\_url) | Base URL of the Bitbucket server to pull changes from. | `string` | n/a | yes |
| <a name="input_atlantis_bitbucket_token"></a> [atlantis\_bitbucket\_token](#input\_atlantis\_bitbucket\_token) | Bitbucket app password of API user. | `string` | n/a | yes |
| <a name="input_atlantis_port"></a> [atlantis\_port](#input\_atlantis\_port) | Port of the container to forward. | `number` | n/a | yes |
| <a name="input_atlantis_repo_allowlist"></a> [atlantis\_repo\_allowlist](#input\_atlantis\_repo\_allowlist) | Atlantis requires you to specify a allowlist of repositories it will accept webhooks from via the --repo-allowlist flag. For example. Specific repositories: --repo-allowlist=github.com/runatlantis/atlantis,github.com/runatlantis/atlantis-tests. Every repository in your GitHub Enterprise install: --repo-allowlist=github.yourcompany.com/* | `list(string)` | n/a | yes |
| <a name="input_atlantis_url"></a> [atlantis\_url](#input\_atlantis\_url) | FQDN the Atlantis server is reachable with. | `string` | n/a | yes |
| <a name="input_atlantis_web_interface_password"></a> [atlantis\_web\_interface\_password](#input\_atlantis\_web\_interface\_password) | BasicAuth password to access the Atlantis web UI. | `string` | n/a | yes |
| <a name="input_atlantis_web_interface_username"></a> [atlantis\_web\_interface\_username](#input\_atlantis\_web\_interface\_username) | BasicAuth username to access the Atlantis web UI. | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the certificate. | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ID of the cluster to deploy the service on. | `string` | n/a | yes |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | Number of cpu units used by the task. | `number` | `2` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | Amount (in MiB) of memory used by the task. | `number` | n/a | yes |
| <a name="input_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#input\_ecs\_task\_execution\_role\_arn) | ARN of the task execution role. | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | URL pointing to the image (Docker registry or similar). | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name prefix used for cluster and additional resources. | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for the LB. | `list(string)` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | Public subnet IDs for the LB. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for the cluster and additional resources. | `map(string)` | <pre>{<br>  "managedby": "terraform"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to run the service on. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_https_listener_arns"></a> [https\_listener\_arns](#output\_https\_listener\_arns) | The ARNs of the HTTPS load balancer listeners. |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | The ID and ARN of the load balancer. |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | ARNs of the target groups. Useful for passing to your Auto Scaling group. |
