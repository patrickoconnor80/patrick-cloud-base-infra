locals {
    prefix      = "patrick-cloud-${var.env}"
    tags = {
        env        = var.env
        type       = "patrick-cloud"
        deployment = "terraform"
        maanged = "patrick-cloud-base-infra/security-groups"
    }
}