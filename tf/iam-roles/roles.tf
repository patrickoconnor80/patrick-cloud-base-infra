resource "aws_iam_role" "snowplow_collector" {
  name        = "${local.prefix}-snowplow-collector-ec2-role"
  description = "Allows the collector nodes to access required services"
  tags        = local.tags

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": [ "ec2.amazonaws.com" ]},
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "snowplow_iglu" {
  name        = "${local.prefix}-snowplow-iglu-ec2-role"
  description = "Allows the Iglu Server nodes to access required services"
  tags        = local.tags

  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": [ "ec2.amazonaws.com" ]},
      "Action": [ "sts:AssumeRole" ]
    }
  ]
}
EOF
}