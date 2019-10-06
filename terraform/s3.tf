resource "aws_s3_bucket" "log_bucket" {
  bucket = "s3-log-bucket"
  acl    = "log-delivery-write"

  tags = "${local.common_tags}"
}

resource "aws_s3_bucket" "site" {
  bucket        = "${var.s3_bucket_name}"
  acl           = "private"
  force_destroy = true
  policy = <<EOF
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_root",
      "Action": ["s3:ListBucket"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name}",
      "Principal": {"AWS":"${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"}
    },
    {
      "Sid": "bucket_policy_site_all",
      "Action": ["s3:GetObject"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.s3_bucket_name}/*",
      "Principal": {"AWS":"${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"}
    }
  ]
}
EOF

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id     = "sit_replication_rule"
      prefix = "set_replication"
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.site_replication.arn}"
        storage_class = "STANDARD"
      }
    }
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  logging {
    target_bucket = "${aws_s3_bucket.log_bucket.id}"
    target_prefix = "log/"
  }

  tags = "${local.common_tags}"
}

resource "aws_s3_bucket" "site_replication" {
  bucket = "${var.s3_bucket_name}-replication"
  region = "us-central-1"

  versioning {
    enabled = true
  }

  tags = "${local.common_tags}"
}