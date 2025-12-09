# Azure Multi Env Terraform Lab

> A small but realistic Terraform lab that provisions a **multi environment** setup on Azure with **modules**, **remote state**, and **CI checks**.  
> Dev stays flexible with public IPs. Prod stays locked down with private only VMs, ready for a more serious world.

---

## 1. Overview

This repo is a Terraform playground that simulates a **real world** Azure setup:

- **Two environments**  
  - `dev` for experimentation and easy SSH access  
  - `prod` for realistic, private only workloads
- **Shared modules**
  - `network` for RG, VNet, subnet, NSG and SSH rule
  - `compute` for Linux VMs and their NICs
- **Remote state in Azure Storage**
- **GitHub Actions CI** that runs:
  - `terraform fmt -check`
  - `terraform validate`

It is designed to be small enough for a free or student subscription but structured like a real Terraform project.

---

## 2. High level design

### 2.1 Environments

- **Dev**
  - Resource group: `rg-terraform-multi-dev` (name may vary)
  - VNet + subnet
  - NSG with SSH allowed from a configurable source IP
  - Two Linux VMs:
    - `vm-terraform-web-dev`
    - `vm-terraform-worker-dev`
  - Both have **public IPs** for easy SSH from the lab machine

- **Prod**
  - Resource group: `rg-terraform-multi-prod`
  - Same network layout as dev
  - Two Linux VMs:
    - `vm-terraform-web-prod`
    - `vm-terraform-worker-prod`
  - VMs are **private only** by design  
    No public IPs. In a real setup you would reach them via Bastion, VPN, or a jump box.

### 2.2 Modules

- `modules/network`
  - Creates:
    - Resource group
    - Virtual network
    - Subnet
    - Network security group
    - SSH inbound rule on port 22
  - Accepts a `tags` map so both dev and prod get consistent tagging.

- `modules/compute`
  - Creates:
    - Public IP (optional)
    - Network interface
    - NSG association
    - Linux virtual machine (Ubuntu 22.04 LTS)
  - Key feature: `enable_public_ip` flag
    - `true` → VM gets a public IP
    - `false` → VM is private only
  - Outputs:
    - VM name
    - VM public IP (or `null` if disabled)

---

## 3. Project structure

```text
azure-multi-env/
  modules/
    network/
      main.tf
    compute/
      main.tf
  envs/
    dev/
      main.tf
      variables.tf
      outputs.tf
      terraform.tfvars
    prod/
      main.tf
      variables.tf
      outputs.tf
      terraform.tfvars
  .github/
    workflows/
      hello.yml
      terraform-dev.yml
      terraform-prod.yml
README.md
