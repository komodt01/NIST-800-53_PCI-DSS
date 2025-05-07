PCI DSS Categories:

Requirement 1: Firewall Configuration
Requirement 6: Vulnerability Management
Requirement 10: Logging & Monitoring
Requirement 11: Testing & Scanning

Firewall Configuration (Req. 1)
# Allow only necessary traffic
sudo ufw allow 443/tcp
sudo ufw allow 80/tcp
sudo ufw enable

Vulnerability Management (Req. 6)
# Install OpenVAS vulnerability scanner
sudo apt install -y openvas
sudo greenbone-feed-sync
sudo gvm-start

Logging & Monitoring (Req. 10)
# Configure Wazuh agent
wget -qO - https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
sudo apt update
sudo apt install wazuh-agent -y
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent

Testing & Scanning (Req. 11)
# Run OpenVAS scan
sudo gvm-cli --xml "<create_target> <name>PCI_Scan</name> <hosts>127.0.0.1</hosts> </create_target>"
