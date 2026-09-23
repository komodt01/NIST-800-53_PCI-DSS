# Linux Hardening – NIST SP 800-53 Control Examples

## Purpose

This document demonstrates Linux security configurations that can support selected NIST SP 800-53 security control objectives.

These examples are intended for hands-on security architecture and hardening practice. Individual commands do not establish NIST SP 800-53 compliance. Control implementation also depends on organizational policy, system context, operational processes, validation, and evidence.

## 1. Account and Access Protection

### Create an Administrative User

```bash
sudo adduser secureuser
sudo usermod -aG sudo secureuser
```

### Restrict SSH Access

```bash
echo "AllowUsers secureuser" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### Password Quality Controls

```bash
sudo apt install libpam-pwquality -y
```

Password requirements should be configured according to the organization's authentication policy and applicable system baseline.

**Related NIST control families:** Access Control (AC), Identification and Authentication (IA)

## 2. Data Protection

Linux Unified Key Setup (LUKS) can be used to protect data stored on Linux block devices.

```bash
sudo cryptsetup luksFormat /dev/sdb
sudo cryptsetup open /dev/sdb secure_volume
sudo mkfs.ext4 /dev/mapper/secure_volume
sudo mount /dev/mapper/secure_volume /mnt/secure
```

> The target device must be verified before running these commands because `luksFormat` is destructive.

**Related NIST control family:** System and Communications Protection (SC)

## 3. Mandatory Access Controls

Ubuntu systems can use AppArmor to restrict application capabilities.

```bash
sudo apt install apparmor -y
sudo systemctl enable apparmor
sudo systemctl start apparmor
sudo aa-status
```

RHEL-based environments commonly use SELinux for comparable mandatory-access-control objectives.

**Related NIST control families:** Access Control (AC), Configuration Management (CM)

## 4. Audit Logging

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

Production audit policies should be defined centrally and made persistent rather than relying only on interactive `auditctl` commands.

**Related NIST control family:** Audit and Accountability (AU)

## 5. Security Logging

Enable the Linux system logging service:

```bash
sudo apt install rsyslog -y
sudo systemctl enable rsyslog
sudo systemctl start rsyslog
```

Review system logs:

```bash
sudo tail -f /var/log/syslog
```

Enterprise environments would typically forward relevant logs to a centralized logging or SIEM platform.

**Related NIST control families:** Audit and Accountability (AU), System and Information Integrity (SI)

## 6. Brute-Force Protection

Fail2Ban can monitor authentication events and temporarily block sources exhibiting repeated failed-login behavior.

```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

This is an example defensive control and should be configured according to the organization's authentication and monitoring requirements.

**Related NIST control families:** Access Control (AC), System and Information Integrity (SI)

## 7. File-Integrity Monitoring

AIDE can establish a baseline of selected filesystem objects and detect subsequent changes.

```bash
sudo apt install aide -y
sudo aideinit
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
sudo aide --check
```

**Related NIST control family:** System and Information Integrity (SI)

## Validation

Technical controls should produce evidence that can be reviewed during security assessments.

Examples include:

- SSH configuration
- Audit rules and audit events
- AppArmor or SELinux status
- Firewall configuration
- File-integrity results
- Authentication events
- Centralized security logs

The architecture relationship is:

**Control Objective → Technical Safeguard → Configuration → Validation Evidence**

## Scope

These commands are examples for a controlled learning environment. They are not a complete NIST SP 800-53 baseline and should not be applied directly to production systems without testing, system-specific configuration, change control, and security review.
