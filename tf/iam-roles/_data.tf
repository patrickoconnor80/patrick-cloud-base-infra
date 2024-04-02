data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

data "aws_vpc" "golden_vpc" {
  filter {
    name   = "tag:Name"
    values = ["golden-vpc"]
  }
}