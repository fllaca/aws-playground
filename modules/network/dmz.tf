resource "aws_subnet" "dmz" {
  count = "${var.availability_zones}"

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${element(var.dmz_cidrs, count.index)}"
  vpc_id            = "${aws_vpc.env.id}"

  tags = "${
    map(
     "Name", "${format("%s-dmz", var.env_name)}"
    )
  }"
}

resource "aws_internet_gateway" "dmz" {
  vpc_id = "${aws_vpc.env.id}"

  tags = {
    Name = "${format("%s-dmz-gw", var.env_name)}"
  }
}

resource "aws_route_table" "dmz" {
  vpc_id = "${aws_vpc.env.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dmz.id}"
  }
}

resource "aws_route_table_association" "dmz" {
  count = "${var.availability_zones}"

  subnet_id      = "${aws_subnet.dmz.*.id[count.index]}"
  route_table_id = "${aws_route_table.dmz.id}"
}

resource "aws_eip" "outbound_nat" {
  count = "${var.availability_zones}"
  vpc = true
}

resource "aws_nat_gateway" "dmz" {
  count = "${var.availability_zones}"

  allocation_id = "${aws_eip.outbound_nat.*.id[count.index]}"
  subnet_id      = "${aws_subnet.dmz.*.id[count.index]}"

  tags = {
    Name = "gw NAT - ${count.index}"
  }
  depends_on = ["aws_subnet.dmz"]
}
