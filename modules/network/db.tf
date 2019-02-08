resource "aws_subnet" "db" {
  count = "${var.availability_zones}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.db_cidrs, count.index)}"
  vpc_id            = "${aws_vpc.env.id}"

  tags = "${
    map(
     "Name", "${format("%s-db", var.env_name)}"
    )
  }"
}

resource "aws_route_table" "db" {
  count = "${var.availability_zones}"

  vpc_id = "${aws_vpc.env.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dmz.*.id[count.index]}"
  }

  depends_on = ["aws_nat_gateway.dmz"]
}

resource "aws_route_table_association" "db" {
  count = "${var.availability_zones}"

  subnet_id      = "${aws_subnet.db.*.id[count.index]}"
  route_table_id = "${aws_route_table.db.*.id[count.index]}"

  depends_on = ["aws_route_table.db"]
}
