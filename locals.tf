locals {
    tags = merge({
        terraform = "true"
        environment = var.env
    }, var.tags)
}