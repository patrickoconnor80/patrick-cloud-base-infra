resource "aws_security_group" "snowplow_collector" {
  name   = "${local.prefix}-snowplow-collector-sg"
  description = "Snowplow Collector EC2 Security Group"
  vpc_id = data.aws_vpc.golden_vpc.id
  tags = merge(local.tags, {Name = "${local.prefix}-snowplow-collector-sg"})
}

resource "aws_security_group" "snowplow_iglu" {
  name   = "${local.prefix}-snowplow-iglu-sg"
  description = "Snowplow Iglu EC2 Security Group"
  vpc_id = data.aws_vpc.golden_vpc.id
  tags = merge(local.tags, {Name = "${local.prefix}-snowplow-iglu-sg"})
}

resource "aws_security_group" "jenkins" {
  name   = "${local.prefix}-jenkins-sg"
  description = "Jenkins EC2 Security Group"
  vpc_id = data.aws_vpc.golden_vpc.id
  tags = merge(local.tags, {Name = "${local.prefix}-jenkins-sg"})
}

resource "aws_security_group" "alb" {
  name        = "${local.prefix}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = data.aws_vpc.golden_vpc.id
  tags = merge(local.tags, {Name = "${local.prefix}-alb-sg"})
}