# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.

data "aws_availability_zones" "available" {}

resource "aws_vpc" "env" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "${var.env_name}",
    )
  }"
}
