# Ops Repair: Restoring the Infrastructure

This project was all about taking a broken deployment and methodically fixing it until it worked. The goal wasn't just to get it running, but to transform a failing codebase into a stable, automated RHEL 10 environment on AWS.

## Project Structure
I kept the infrastructure separate from the configuration logic, just to keep things organized.

```text
.
├── ansible/                 # Configuration Management
│   ├── ansible.cfg          # Ansible Control Configuration
│   ├── playbooks/           # Orchestration Logic
│   └── roles/               # Reusable Configuration Units (system_core)
├── terraform/               # Infrastructure as Code
│   ├── main.tf              # Root Module & Inventory Generation
│   └── modules/             # Encapsulated Resources
│       ├── compute/         # EC2 Computation Logic
│       └── networking/      # VPC and Subnet Topology
└── README.md                # Documentation
```

## The Infrastructure (Terraform)
I used Terraform to lay the foundation in `af-south-1`. The original modules were struggling, so I had to debug them to get a reliable network and compute layer up.

*   **Networking**: I set up a standard VPC (`10.0.0.0/16`) with a public subnet (`10.0.1.0/24`) to give me a place to work.
*   **Compute**: A single `t3.micro` instance running RHEL 10. I made sure it had the right SSH keys so I could actually get in.
*   **Handoff**: One of the handy things I fixed was making sure Terraform pipes the server's IP directly into the Ansible inventory, so I don't have to copy-paste it manually.

## The Configuration (Ansible)
Once the server is up, Ansible takes over to set up the system state. The main focus here was fixing the logic errors in the `system_core` role so it could run without failing.

*   **Users**: It sets up the `ec2-user` properly (it was failing with a mismatch before).
*   **Storage**: I automate the creation of a loopback device at `/opt/backup` and format it with XFS.
*   **Automation**: Systemd units (`backup.timer`) are deployed to handle scheduled tasks.

## What I Fixed
The debugging process was really the core of this project. Here is what I actually had to repair:

*   **Terraform Syntax**: There were some broken block definitions in the compute modules that needed cleaning up.
*   **SSH Access**: The Ansible configuration was trying to connect as the wrong user, so I aligned it with the default AWS AMI user to get the handshake working.
*   **Systemd Paths**: The unit files had some pathing errors that prevented services from starting.
*   **Ansible Handlers**: I fixed a case-sensitivity issue where the "restart services" handler wasn't firing when it should have.
