provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key

  endpoints {
    ec2 = var.run_on_aws == true ? null : "https://${var.symphony_ip}/api/v2/aws/ec2"
  }

  insecure                    = var.run_on_aws == true ? null : true
  skip_metadata_api_check     = var.run_on_aws == true ? null : true
  skip_credentials_validation = var.run_on_aws == true ? null : true
  skip_requesting_account_id  = var.run_on_aws == true ? null : true

  # No importance for this value currently
  region = "us-east-1"
}

