## Requirements

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_alias | The desired AWS account alias. | `string` | n/a | yes |
| bucket\_purpose | Name to identify the bucket's purpose | `string` | `"tf-state"` | no |
| region | AWS region. | `string` | n/a | yes |
| tags | Tags of the DynamoDB Table for locking Terraform state. | `map(string)` | <pre>{<br>  "managedby": "terraform",<br>  "owner": "owner"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The statefile bucket name |
| dynamodb\_table | The name of the dynamo db table |

