terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "af-south-1"
}

module "networking" { source = "./modules/networking" }
module "compute" {
  source    = "./modules/compute"
  vpc_id    = module.networking.vpc_id
  subnet_id = module.networking.subnet_id
}

resource "local_file" "ansible_inventory" {
  content = <<EOF
        [rhce_nodes]
        [rhce_nodes]
        ${module.compute.public_ip}

        [lab:children]
        rhce_nodes

        [lab:vars]
        ansible_python_interpreter=/usr/bin/python3
        ansible_ssh_private_key_file=~/.ssh/Terra.pem
        EOF

  filename = "../ansible/inventory/hosts.ini"
}

