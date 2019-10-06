provider "aws" {
  access_key = "${var.AWS_KEY}"
  secret_key = "${var.AWS_SECRET}"
  region = "${var.aws_region}"
}

provider "aws" {
  alias  = "central"
  region = "us-central-1"
}