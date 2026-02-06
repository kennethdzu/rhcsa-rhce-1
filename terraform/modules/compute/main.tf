variable "vpc_id" {}
variable "subnet_id" {}


#data "aws_ami" "rhel" {
#    most_recent    = true
#   owners          = ["309956199498"]
#
#    filter { 
#        name       = "name"  
#        values     = ["RHEL-9.*"]
#    }
#}

resource "aws_security_group" "demo-me-sg" {
  vpc_id = var.vpc_id
  name   = "rhce-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "demo-me-node" {
  ami                    = "ami-00a27ff50ac40e62a"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.demo-me-sg.id]
  key_name               = "Terra"

  tags = { Name = "rhce-node" }
}

output "public_ip" { value = aws_instance.demo-me-node.public_ip }

