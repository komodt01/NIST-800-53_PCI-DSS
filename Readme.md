# Multi-Cloud Compliance Lab – NIST SP 800-53 + PCI DSS

## Overview

This hands-on security lab explores how infrastructure configuration and Linux hardening controls can support compliance objectives from **NIST SP 800-53** and **PCI DSS** across **AWS, Azure, and Google Cloud Platform (GCP)**.

The objective is not to demonstrate full regulatory compliance. Instead, the lab connects security requirements to practical technical controls and shows how similar security objectives can be implemented across different cloud platforms.

## Lab Objectives

The lab focuses on several common security objectives:

- Deploy Linux virtual machines across AWS, Azure, and GCP
- Apply Linux operating-system hardening techniques
- Restrict network access and administrative connectivity
- Configure logging and auditing
- Explore vulnerability detection and monitoring
- Implement file-integrity monitoring concepts
- Protect data through encryption
- Map technical safeguards to relevant NIST SP 800-53 and PCI DSS control objectives

## Architecture Approach

The lab follows a simple control-driven model:

**Security Requirement → Technical Control → Cloud / Linux Implementation → Validation**

Although AWS, Azure, and GCP use different services and configuration models, the underlying security requirements remain similar.

Examples include:

| Security Objective | Example Implementation |
| --- | --- |
| Network protection | Cloud firewall rules, UFW, iptables |
| Administrative access | SSH hardening and key-based authentication |
| Logging and auditing | rsyslog, auditd |
| Vulnerability management | Vulnerability scanning concepts |
| File integrity | AIDE |
| Security monitoring | Wazuh concepts |
| Data protection | Linux and cloud encryption controls |

## Repository Contents

### Terraform

The `Terraform/` directory contains example infrastructure configurations for deploying Linux virtual machines in:

- AWS
- Azure
- GCP

These configurations provide the infrastructure foundation for experimenting with security controls in each cloud environment.

### Linux Hardening

The repository also contains command references covering:

- Linux VM security configuration
- NIST SP 800-53-aligned security controls
- PCI DSS-aligned security controls
- Cloud-specific Linux VM setup

These commands are intended for lab experimentation and learning rather than production deployment.

## Compliance Mapping

This lab uses NIST SP 800-53 and PCI DSS as reference frameworks for understanding how technical controls support broader security requirements.

Examples include controls related to:

- Access control
- Network protection
- Audit logging
- Vulnerability management
- System integrity
- Encryption and data protection

A technical configuration alone does not establish compliance. Organizational policies, procedures, governance, evidence, testing, and operational processes are also required.

## What This Lab Demonstrates

This project demonstrates the relationship between:

**Compliance Requirement → Security Architecture Decision → Technical Implementation → Validation Evidence**

The emphasis is on understanding why a control exists, how it can be implemented technically, and how implementation evidence can support security and compliance reviews.

## Scope

This repository is a hands-on learning environment and reference implementation. It is not intended to represent a complete NIST SP 800-53 or PCI DSS compliance program, certified environment, or production-ready security baseline.

## Technologies

- AWS
- Microsoft Azure
- Google Cloud Platform
- Terraform
- Linux
- UFW / iptables
- auditd
- AIDE
- Wazuh
- Vulnerability scanning concepts

## Key Takeaway

Cloud platforms implement security controls differently, but the underlying security requirement can remain consistent.

The architectural goal is therefore to standardize the **security objective and required outcome** while allowing the implementation to reflect the capabilities of each cloud platform.
