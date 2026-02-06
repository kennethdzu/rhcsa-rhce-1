

variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "subnet_cidr" { default = "10.0.1.0/24" }

resource "aws_vpc" "demo-me-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "rhce-vpc" }
}

resource "aws_subnet" "demo-me-sbnet" {
  vpc_id                  = aws_vpc.demo-me-vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "demo-me-gw" { vpc_id = aws_vpc.demo-me-vpc.id }

resource "aws_route_table" "demo-me-rt" {
  vpc_id = aws_vpc.demo-me-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-me-gw.id
  }
}

resource "aws_route_table_association" "demo-me-rtassoc" {
  subnet_id      = aws_subnet.demo-me-sbnet.id
  route_table_id = aws_route_table.demo-me-rt.id
}

output "vpc_id" { value = aws_vpc.demo-me-vpc.id }
output "subnet_id" { value = aws_subnet.demo-me-sbnet.id }

