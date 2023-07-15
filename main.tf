terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

variable "prefix" {
  type    = string
  default = "tfstate"
}

resource "random_string" "random_id" {
  keepers = {

  }
  length  = 8
  special = false
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.prefix}-${random_string.random_id.id}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    terraform = "true"
  }
}

resource "aws_s3_bucket_public_access_block" "state_bucket_public_access_block" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket_encryption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "state_lock" {
  name             = "${var.prefix}-${random_string.random_id.id}"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "LockID"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    terraform = "true"
  }
}

