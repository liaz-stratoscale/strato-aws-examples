# Configure the Amazon AWS Provider
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  endpoints {
    ec2     = "https://${var.symphony_ip}/api/v2/aws/ec2"
    iam     = "https://${var.symphony_ip}/api/v2/aws/iam"
    route53 = "https://${var.symphony_ip}/api/v2/aws/route53"
  }

  insecure                    = true
  skip_metadata_api_check     = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  # No importance for this value currently
  region = "us-east-2"
}