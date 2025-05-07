# Linux Commands for NIST 800-53 Compliance

## **1. Access Control (AC-2, AC-3)**
### Create a Least-Privilege User:
```bash
sudo adduser secureuser
sudo usermod -aG sudo secureuser
```
### Restrict SSH Access:
```bash
echo "AllowUsers secureuser" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### Enforce Password Complexity:
```bash
sudo apt install libpam-pwquality -y
sudo sed -i 's/^password    requisite.*/password    requisite    pam_pwquality.so retry=3 minlen=12 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password
```

## **2. System & Communications Protection (SC-12, SC-13)**
### Encrypt Disk Storage:
```bash
sudo cryptsetup luksFormat /dev/sdb
sudo cryptsetup open /dev/sdb secure_volume
mkfs.ext4 /dev/mapper/secure_volume
mount /dev/mapper/secure_volume /mnt/secure
```

### Enable SELinux (for RHEL-based) or AppArmor (for Ubuntu-based):
```bash
sudo apt install apparmor -y
sudo systemctl enable apparmor
sudo systemctl start apparmor
sudo aa-status
```

## **3. Audit & Accountability (AU-2, AU-3)**
### Enable and Configure Audit Logging:
```bash
sudo apt install auditd -y
sudo systemctl enable auditd
sudo systemctl start auditd
sudo auditctl -w /etc/passwd -p wa -k passwd_changes
sudo auditctl -w /var/log/auth.log -p wa -k auth_logs
sudo service auditd restart
```

## **4. Risk Assessment & Vulnerability Management (RA-5, SI-2)**
### Install and Run OpenVAS:
```bash
wget -qO - https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
sudo apt update
sudo apt install -y openvas wazuh-agent
sudo greenbone-feed-sync
sudo gvm-start
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

## **5. Logging & Monitoring (AU-12, AU-14)**
### Enable Logging and Forward Logs:
```bash
sudo apt install rsyslog -y
sudo systemctl enable rsyslog
sudo systemctl start rsyslog
sudo tail -f /var/log/syslog
```

## **6. Intrusion Prevention & Brute Force Protection (SI-4, SI-7)**
### Install and Configure Fail2Ban:
```bash
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

## **7. Application Security & Integrity Checks (SI-7, CM-5)**
### Enable File Integrity Monitoring (AIDE):
```bash
sudo apt install aide -y
sudo aideinit
sudo mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
sudo aide --check
```
