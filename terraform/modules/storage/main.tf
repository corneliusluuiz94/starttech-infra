terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

# ---------------- S3 Static Site Bucket (Private, OAC-only access) ----------------
resource "aws_s3_bucket" "starttech-frontend-bucket" {
  bucket = "starttech-frontend-bucket-${random_id.suffix.hex}"

  tags = {
    Name = "starttech-frontend-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "starttech-frontend-bucket" {
  bucket = aws_s3_bucket.starttech-frontend-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "starttech-frontend-bucket" {
  bucket = aws_s3_bucket.starttech-frontend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "starttech-frontend-bucket" {
  bucket = aws_s3_bucket.starttech-frontend-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# NOTE: The bucket policy granting CloudFront (OAC) read access is applied in the
# ROOT module (terraform/main.tf), not here, because it needs the CloudFront
# distribution ARN, which in turn depends on this bucket -- applying it in root
# breaks the module-to-module circular dependency.

# ---------------- ECR Repository for Backend Container Images ----------------
resource "aws_ecr_repository" "starttech-backend-api" {
  name                 = "starttech-backend-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "starttech-backend-api"
  }
}
