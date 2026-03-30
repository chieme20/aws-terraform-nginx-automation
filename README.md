Automated AWS Web Infrastructure with Terraform

Project Overview
This repository contains **Infrastructure as Code (IaC)** to deploy a fully functional, secure, and automated web server environment on AWS. Instead of manual configuration, I used **Terraform** to architect a Virtual Private Cloud (VPC) from scratch and bootstrap an **Nginx** web server.

### Why this is "Production-Ready":
- **Zero Manual Setup:** The entire networking stack is defined in code.
- **Automated Bootstrapping:** Uses EC2 User Data (Bash) to install software on the first boot.
- **Security-Centric:** Implements a Security Group "Firewall" following the principle of least privilege.

---
![Web Server Success](./screenshot.png)
##  Architecture Components
- **VPC:** Custom 10.0.0.0/16 network for isolated cloud resources.
- **Public Subnet:** Hosted in `us-east-1a` to provide internet access to the web server.
- **Internet Gateway (IGW):** The bridge between the VPC and the public internet.
- **Route Table:** Configured to direct all outbound traffic (0.0.0.0/0) to the IGW.
- **Security Group:** Acting as a virtual firewall, allowing:
  - **Port 80 (HTTP):** For public web traffic.
  - **Port 22 (SSH):** For secure administrative access.
- **EC2 Instance:** A `t3.micro` instance running **Ubuntu 20.04 LTS**.

---

##  Technology Stack
- **Cloud Provider:** AWS (Amazon Web Services)
- **IaC Tool:** Terraform v1.7.5
- **Web Server:** Nginx
- **OS:** Ubuntu Linux

---

##  Deployment Instructions

### 1. Prerequisites
- AWS CLI configured with your credentials.
- Terraform installed on your local machine.

### 2. Initialization
Initialize the working directory and download the AWS provider:
`terraform init`

### 3. Execution
Review the execution plan and deploy the infrastructure:
`terraform apply -auto-approve`

### 4. Cleanup
To avoid unnecessary AWS costs, destroy the resources after testing:
`terraform destroy -auto-approve`

---

## Key Learning Outcomes
1. **Infrastructure as Code (IaC):** Mastered the declarative syntax of HCL to manage cloud lifecycles.
2. **Cloud Networking:** Deep understanding of VPCs, Subnets, and Route Tables.
3. **Linux Administration:** Automated software installation using Bash scripts via Cloud-Init (User Data).
4. <img width="956" height="429" alt="welcome" src="https://github.com/user-attachments/assets/08e29cc2-2136-4948-9ea6-d32ef8715ab8" />
<img width="956" height="429" alt="welcome" src="https://github.com/user-attachments/assets/0f8812bb-482a-40d4-aed9-ecbde28d3e5b" />
