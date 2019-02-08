module "network" {
    source = "./modules/network"

    env_name = "${var.env_name}"

    vpc_cidr = "${var.vpc_cidr}"
    dmz_cidrs = ["${var.dmz_cidrs}"]
    db_cidrs = ["${var.db_cidrs}"]
}