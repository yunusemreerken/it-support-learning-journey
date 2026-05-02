# DHCP Server Setup & Configuration — NordBank Lab
**Environment:** Windows Server 2025 | Domain: `lab.local` | DC: DC01.lab.local

---

## Overview

Installed and configured DHCP Server role on DC01 to automatically distribute IP addresses to client machines across the NordBank network.

---

## Installation

```
Server Manager → Add Roles and Features →
Role-based installation →
Select DC01 →
✅ DHCP Server →
Next → Install
```

After installation:
```
Server Manager → ⚠️ Complete DHCP Configuration → Commit → Close
```

---

## Scope Configuration

### NordBank-Istanbul Scope

| Setting | Value |
|---------|-------|
| Scope Name | NordBank-Istanbul |
| Start IP | 192.168.1.100 |
| End IP | 192.168.1.200 |
| Subnet Mask | 255.255.255.0 |
| Exclusions | 192.168.1.1 — 192.168.1.50 |
| Lease Duration | 8 hours |
| Default Gateway | 192.168.1.1 |
| DNS Server | 192.168.1.10 (DC01) |
| WINS | Not configured (deprecated) |

---

## Exclusion Range Explained

```
192.168.1.1          → Modem / Default Gateway
192.168.1.2 - .9     → Reserved for network devices
192.168.1.10         → DC01 (static)
192.168.1.11 - .50   → Reserved for servers / static devices
─────────────────────────────────────────────────────
192.168.1.100 - .200 → DHCP Pool (clients get IPs here)
```

---

## Firewall Rule Added

DHCP was not responding to clients until a firewall rule was added:

```powershell
netsh advfirewall firewall add rule name="DHCP Server" protocol=UDP dir=in localport=67 action=allow
```

---

## Test Results

Client (WIN11CLIENT) successfully obtained IP from DHCP pool:

```
DHCP Enabled: Yes
IPv4 Address: 192.168.1.135
Subnet Mask:  255.255.255.0
Default Gateway: 192.168.1.1
```

---

## Useful Commands

```powershell
# Check DHCP service status
Get-Service DHCPServer

# List all scopes
Get-DhcpServerv4Scope

# List all active leases
Get-DhcpServerv4Lease -ScopeId 192.168.1.0

# Release and renew IP on client
ipconfig /release
ipconfig /renew
ipconfig /all
```

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `169.254.x.x` IP on client | DHCP server not responding | Check firewall, check scope is active |
| `ipconfig /release` fails | Not running as Administrator | Open CMD as Administrator |
| Scope not distributing IPs | Scope not activated | `dhcpmgmt.msc → Scope → Right click → Activate` |

---

*Lab built as part of IT Support & SysAdmin learning journey.*
