# Linux Hardening – PCI DSS Security Control Examples

## Purpose

This document demonstrates Linux security configurations that can support selected PCI DSS security objectives for systems within or supporting a cardholder data environment.

These examples are intended for hands-on security architecture and hardening practice. Individual commands do not establish PCI DSS compliance. Applicability depends on system scope, architecture, organizational policies, operational processes, testing, and assessment requirements.

## 1. Network Access Protection

A host-based firewall can restrict unnecessary inbound network connectivity.

### Ubuntu / Debian – UFW

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 443/tcp
sudo ufw enable
sudo ufw status
```

Ports should only be permitted when required by the workload and approved architecture.

**PCI DSS objective:** Restrict network access to necessary systems, services, and communication paths.

## 2. Administrative Access

Disable direct root login through SSH:

```bash
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
```

Disable password-based SSH authentication where key-based authentication is the approved access method:

```bash
sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

Access controls should be integrated with the organization's broader identity, authentication, authorization, and privileged-access strategy.

**PCI DSS objective:** Restrict and authenticate administrative access.

## 3. Audit Logging

Install and enable Linux auditing:

```bash
sudo apt install auditd -y
sudo systemctl enable auditd
sudo systemctl start auditd
```

Example audit watches:

```bash
sudo auditctl -w /etc/passwd -p wa -k passwd_changes
sudo auditctl -w /var/log/auth.log -p wa -k auth_logs
```

Production environments should use persistent audit policies and centralized collection appropriate to the system's role.

**PCI DSS objective:** Record and monitor security-relevant activity.

## 4. File-Integrity Monitoring

AIDE can establish a baseline and detect changes to monitored filesystem objects.

```bash
sudo apt install aide -y
sudo aideinit
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
sudo aide --check
```

File-integrity monitoring should focus on files and configurations relevant to the security of the environment.

**PCI DSS objective:** Detect unauthorized modification of critical system components.

## 5. Brute-Force Protection

Fail2Ban can monitor authentication events and temporarily block sources generating repeated failed-login attempts.

```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

This represents one possible defensive mechanism and does not replace appropriate authentication, access-control, and monitoring architecture.

**PCI DSS objective:** Protect authentication mechanisms and administrative access.

## 6. Data-at-Rest Protection

Linux Unified Key Setup (LUKS) can provide encryption for Linux block devices.

```bash
sudo cryptsetup luksFormat /dev/sdb
sudo cryptsetup open /dev/sdb secure_data
sudo mkfs.ext4 /dev/mapper/secure_data
sudo mount /dev/mapper/secure_data /mnt/secure
```

> Verify the target device before using `luksFormat`. Formatting the wrong device can destroy existing data.

Encryption architecture must also address key management, authorization, recovery, rotation, and other applicable requirements.

**PCI DSS objective:** Protect stored account data where applicable.

## 7. Vulnerability Management

Vulnerability assessment should identify known weaknesses affecting in-scope systems.

Rather than assuming a particular scanner or installation method, the security architecture should define:

- Assets subject to scanning
- Scan frequency
- Authenticated versus unauthenticated scanning
- Vulnerability severity thresholds
- Remediation expectations
- Exception handling
- Rescanning and validation requirements
- Evidence retention

The specific vulnerability-management platform can then be selected according to enterprise requirements.

**PCI DSS objective:** Identify, prioritize, and remediate security vulnerabilities.

## Validation Evidence

Technical safeguards should produce evidence that can support security and compliance reviews.

Examples include:

- Firewall rules
- SSH configuration
- Authentication logs
- Audit events
- File-integrity results
- Encryption configuration
- Vulnerability scan results
- Remediation records

The architecture relationship is:

**PCI DSS Requirement → Security Objective → Technical Safeguard → Validation Evidence**

## Scope

These examples are intended for a controlled learning environment. They do not constitute a complete PCI DSS implementation or demonstrate that a system or organization is PCI DSS compliant.

Production implementation requires appropriate scoping, governance, policies, procedures, testing, evidence collection, operational controls, and assessment.
