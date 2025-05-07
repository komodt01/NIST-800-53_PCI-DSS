# Security Compliance for Linux VMs

## Overview
This repository provides security compliance configurations for **Linux Virtual Machines** deployed in **AWS, Azure, and GCP**. The configurations align with **PCI DSS 4.0** and **NIST 800-53** requirements, implementing essential security controls such as **firewall rules, intrusion prevention, vulnerability scanning, logging, and encryption**.

## Included Resources
### 1. **Terraform Scripts for Cloud Deployment**
- **AWS:** Deploys an Amazon Linux 2 VM with **Wazuh & OpenVAS** pre-installed.
- **Azure:** Deploys an Ubuntu VM with **Wazuh & OpenVAS** using Azure VM Extensions.
- **GCP:** Deploys a Debian-based VM with **Wazuh & OpenVAS** pre-configured.

### 2. **Linux Security Hardening Commands**
- **PCI DSS 4.0 Compliance** (`linux_commands_pci_dss`)
- **NIST 800-53 Compliance** (`linux_commands_nist_800_53`)
- **Linux VM Setup Commands for Each Cloud Provider** (`linux_commands_setup_vms`)

## Security Controls Implemented
| Security Control  | PCI DSS 4.0  | NIST 800-53  | Implementation |
|------------------|-------------|--------------|----------------|
| Firewall Rules  | ✅ Req 1     | ✅ SC-7      | UFW / iptables |
| SSH Hardening   | ✅ Req 8     | ✅ AC-2      | No root login, Key-based SSH |
| Intrusion Prevention | ✅ Req 11  | ✅ SI-4      | Fail2Ban, Wazuh |
| Logging & Monitoring | ✅ Req 10  | ✅ AU-12     | Rsyslog, Auditd |
| Vulnerability Scanning | ✅ Req 11  | ✅ RA-5      | OpenVAS |
| File Integrity Monitoring | ✅ Req 10  | ✅ SI-7      | AIDE |
| Disk Encryption | ✅ Req 3.5  | ✅ SC-12     | LUKS, dm-crypt |

## Prerequisites
Before running any security commands, ensure the following:
1. **Update Package Lists**:
   ```bash
   sudo apt update -y && sudo apt upgrade -y
   ```
2. **Install Required Repositories**:
   ```bash
   wget -qO - https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
   echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
   ```
3. **Verify Security Services Are Running**:
   ```bash
   systemctl status wazuh-agent
   systemctl status fail2ban
   systemctl status auditd
   ```

## Deployment Instructions
1. **Deploy Linux VMs Using Terraform**:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
2. **Run Security Hardening Scripts**:
   ```bash
   bash security_hardening.sh
   ```
3. **Validate Compliance**:
   ```bash
   sudo aide --check  # File Integrity Monitoring
   sudo auditctl -l   # Verify audit rules
   sudo gvm-start     # Start OpenVAS
   ```

## Compliance Validation
To confirm that your Linux VMs meet **PCI DSS 4.0** and **NIST 800-53** compliance:
- Review **audit logs** (`/var/log/auth.log`, `/var/log/audit/audit.log`)
- Run **OpenVAS scans** to identify vulnerabilities
- Verify **firewall rules** (`ufw status` or `iptables -L`)

## Next Steps
- Automate security checks with **Ansible**.
- Configure **SIEM integration** for central log monitoring.
- Expand coverage for **CIS Benchmark compliance**.

---
For questions or improvements, feel free to contribute! 🚀
