# Bootstrap AWS S3 Bucket for Terraform State

This repository contains Terraform code to bootstrap an AWS S3 Bucket for storing Terraform state. The code creates a new S3 bucket and a DynamoDB table for state locking.

## Prerequisites

Before you can use this Terraform code, you must have the following:

- An AWS account
- AWS CLI installed on your local machine
- Terraform installed on your local machine

## Variables

The following variables are defined in `main.tf`:

| Variable     | Description                                                           | Default Value     |
| ------------ | --------------------------------------------------------------------- | ----------------- |
| `aws_region` | The AWS region in which to create the S3 bucket and DynamoDB table.   | `us-west-2`       |
| `prefix`     | A prefix to prepend to the names of the S3 bucket and DynamoDB table. | `terraform-state` |

## Lifecycle

The Terraform code in this repository is intended to be used once to bootstrap an S3 bucket for storing Terraform state. Once the S3 bucket has been created, you should update your Terraform configuration to use the new S3 bucket as a backend. Take note of the lifecycle block in `aws_s3_bucket`:

```hcl
lifecycle {
  prevent_destroy = true
}
```

This block prevents the S3 bucket from being destroyed by Terraform. This is to prevent accidental deletion of the S3 bucket and the Terraform state stored within it. If you need to destroy the S3 bucket, you must first remove the `prevent_destroy` block from the code.

## Usage

1. Clone this repository to your local machine.
2. Change into the directory containing the cloned repository.
3. Run `terraform init` to initialize the Terraform configuration.
4. Run `terraform plan` to see what resources will be created.
5. Run `terraform apply` to create the resources.
6. Update your Terraform configuration to use the new S3 bucket as a backend.
7. Run `terraform init` to initialize the Terraform configuration.
8. Run `terraform plan` to see what changes will be made to your infrastructure.
9. Run `terraform apply` to apply the changes to your infrastructure.

## License

This code is released under the MIT License. See [LICENSE](LICENSE) for details.
