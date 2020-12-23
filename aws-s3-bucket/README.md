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
| bucket\_name | The name of the bucket. | `string` | n/a | yes |
| enable\_bucket\_force\_destroy | If set to true, Bucket will be emptied and destroyed when terraform destroy is run. | `bool` | `false` | no |
| enable\_versioning | Enables versioning on the bucket. | `bool` | `true` | no |
| tags | A mapping of tags to assign to the bucket. | `map(string)` | `{}` | no |
| use\_account\_alias\_prefix | Whether to prefix the bucket name with the AWS account alias. | `string` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| bucket\_domain\_name | The bucket domain name. |
| bucket\_regional\_domain\_name | The bucket region-specific domain name. |
| id | The name of the bucket. |
| name | The Name of the bucket. Will be of format bucketprefix-bucketname. |

