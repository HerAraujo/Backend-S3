
terraform {
  backend "s3" {
    bucket = "tf-infraestructura-como-codigo-hernan"
    key    = "servidor/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "tf-infraestructura-como-codigo-hernan"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state_hernan" {
  bucket = "tf-infraestructura-como-codigo-hernan"
  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tf-infraestructura-como-codigo-hernan"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_instance" "servidor" {
  instance_type = "t2.micro"
  ami           = "ami-00eeedc4036573771"

  tags = {
    "name" = "servidor-prueba"
  }
}
