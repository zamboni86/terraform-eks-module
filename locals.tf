locals {
    tags = merge({
        terraform = "true"
        environment = "dev"
    }, var.tags)
}