data "aws_ami" "bastion" {
  filter {
    name   = "name"
    values = ["debian-stretch-hvm-x86_64-gp2-2019-01-22-59357"]
  }

  most_recent = true
  owners      = ["379101102735"] # Amazon EKS AMI Account ID
}

resource "aws_eip" "bastion" {
  vpc = true
}
resource "aws_key_pair" "bastion" {
  key_name   = "deployer-key"
  public_key = "${var.ssh_pub_key_deployer}"
}

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Used in the terraform"

  vpc_id = "${module.network.vpc_id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  instance_type = "t2.micro"

  ami = "${data.aws_ami.bastion.id}"
  key_name = "${aws_key_pair.bastion.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  subnet_id = "${element(module.network.subnet_dmz_ids, 0)}"

  #Instance tags
  tags = {
    Name = "eip-example"
    Enviroment = "${var.env_name}"
  }

  depends_on = ["module.network"]
}
