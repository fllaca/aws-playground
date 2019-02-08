output "vpc_id" {
  value = "${aws_vpc.env.id}"
}

output "subnet_dmz_ids" {
  value = ["${aws_subnet.dmz.*.id}"]
}

output "subnet_db_ids" {
  value = ["${aws_subnet.db.*.id}"]
}