# [1.5.0](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/compare/1.4.0...1.5.0) (2024-04-10)


### Features

* **pipeline:** Add terraform-docs to pipeline run ([2bf6b67](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/commits/2bf6b67d5813ab42dedcaf81884cbb0c7ebc1970))

# [1.4.0](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/compare/1.3.1...1.4.0) (2024-03-28)


### Features

* **pipeline:** add checkov to pipeline ([e434029](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/commits/e434029615a8b7c1c4a98435a114a6757c0484ce))

## [1.3.1](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/compare/1.3.0...1.3.1) (2024-01-17)


### Bug Fixes

* **sops:** actually attach the policy to the role ([188448e](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/commits/188448ef22aa6efd03bd3dcbbcf607e26d2bbaf7))

# [1.3.0](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/compare/1.2.0...1.3.0) (2024-01-17)


### Features

* **sops:** allow access to sops key ([74dbdf4](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/commits/74dbdf43157ed7e3be9758cd9e068e3ea5f67e40))

# [1.2.0](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/compare/1.1.5...1.2.0) (2023-09-18)


### Features

* **assume role policy:** allowed role assumption in all subaccounts ([267b603](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/commits/267b603c09c0c7ab7941c77a32e6811282794bee))

## [1.1.5](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/compare/1.1.4...1.1.5) (2023-09-18)


### Bug Fixes

* **policy attachment:** use arn for policy attachment ([e0d4d65](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/commits/e0d4d65db341050c72e36e98b9d378b1420be9ae))

## [1.1.4](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/compare/1.1.3...1.1.4) (2023-09-18)


### Bug Fixes

* **variables:** removed ec2 instance id since we are attaching the profile to a single instance which makes the argument obsolete ([a9881d4](https://bitbucket.org/metamorphant/aws-iam-atlantis-instance-profile/commits/a9881d403d9948ee193b527bcb4dc9dab5bf6966))

## [1.1.3](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/compare/1.1.2...1.1.3) (2023-09-18)


### Bug Fixes

* **instance profile:** build a full iam instance profile instead of attaching policies to another role ([f9c91ec](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/commits/f9c91ec7bdd03ed1b6f7a941fc5e8225e36baab0))

## [1.1.2](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/compare/1.1.1...1.1.2) (2023-09-17)


### Bug Fixes

* **policy:** use policy arn for attachment ([d698e8e](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/commits/d698e8e8c5febf357b9f3e5cb897627139006900))

## [1.1.1](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/compare/1.1.0...1.1.1) (2023-09-17)


### Bug Fixes

* **policy:** tansfer policy document into policy ([e577ddb](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/commits/e577ddb881a6c4b5e1cccd4ecbc87f805e6ffc1a))

# [1.1.0](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/compare/1.0.0...1.1.0) (2023-09-17)


### Features

* **iam-instance-profile:** added ec2 instance profile shell ([74c4f9c](https://bitbucket.org/metamorphant/aws-terraform-assumerole-ec2-instance/commits/74c4f9c1a152689433ddcad654cad11aaf929588))
