# Linux Commands for PCI DSS Compliance

## **1. Configure Firewall Rules (Requirement 1)**
### For Ubuntu/Debian (UFW):
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

### For RHEL/CentOS (iptables):
```bash
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables-save | sudo tee /etc/sysconfig/iptables
```

## **2. Enable File Integrity Monitoring (Requirement 10.5)**
### Install and Configure AIDE:
```bash
sudo apt install aide -y  # Debian-based
sudo yum install aide -y  # RHEL-based
sudo aideinit
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
sudo aide --check
```

## **3. Enable Auditing (Requirement 10.2 & 10.3)**
```bash
sudo apt install auditd -y
sudo systemctl enable auditd
sudo systemctl start auditd
sudo auditctl -w /etc/passwd -p wa -k passwd_changes
sudo auditctl -w /var/log/auth.log -p wa -k auth_logs
```

## **4. Harden SSH Access (Requirement 8.2)**
```bash
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

## **5. Enforce Strong Password Policies (Requirement 8.2.3)**
```bash
sudo apt install libpam-pwquality -y
sudo sed -i 's/^password    requisite.*/password    requisite    pam_pwquality.so retry=3 minlen=12 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password
```

## **6. Install and Configure Fail2Ban (Requirement 11.4)**
```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

## **7. Encrypt Data at Rest (Requirement 3.5 & 3.6)**
### Encrypt Disk with LUKS:
```bash
sudo cryptsetup luksFormat /dev/sdb
sudo cryptsetup open /dev/sdb secure_data
mkfs.ext4 /dev/mapper/secure_data
mount /dev/mapper/secure_data /mnt/secure
```

## **8. Perform Vulnerability Scanning (Requirement 11.2)**
### Install and Run OpenVAS:
```bash
sudo apt install -y openvas
sudo greenbone-feed-sync
sudo gvm-start
