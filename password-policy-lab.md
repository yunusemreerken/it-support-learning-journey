# Password Policy & Account Lockout — NordBank Lab
**Environment:** Windows Server 2025 | Domain: `lab.local` | GPO: Default Domain Policy

---

## Overview

Configured domain-wide password and account lockout policies via Group Policy to enforce security standards across all NordBank users.

---

## Configuration Path

```
gpmc.msc → Default Domain Policy → Edit →
Computer Configuration
└── Policies
     └── Windows Settings
          └── Security Settings
               └── Account Policies
```

---

## Password Policy Settings

| Policy | Value |
|--------|-------|
| Enforce password history | 5 passwords remembered |
| Maximum password age | 90 days |
| Minimum password age | 1 day |
| Minimum password length | 10 characters |
| Password must meet complexity requirements | Enabled |
| Store passwords using reversible encryption | Disabled |

---

## Account Lockout Policy Settings

| Policy | Value |
|--------|-------|
| Account lockout duration | 30 minutes |
| Account lockout threshold | 5 invalid logon attempts |
| Allow Administrator account lockout | Enabled |
| Reset account lockout counter after | 30 minutes |

---

## Key Notes

- Password and Account Lockout policies **must** be configured in **Default Domain Policy** — not in custom GPOs
- These policies apply **domain-wide** to all users
- Complexity requirements mean passwords must contain uppercase, lowercase, numbers, and special characters
- After 5 failed login attempts, the account is automatically locked for 30 minutes

---

## Useful Commands

```powershell
# Check if an account is locked
Get-ADUser -Identity b.yildiz -Properties LockedOut | Select-Object Name, LockedOut

# Unlock a locked account
Unlock-ADAccount -Identity b.yildiz

# Find all locked accounts
Search-ADAccount -LockedOut | Select-Object Name, LockedOut

# Force GPO refresh
gpupdate /force
```

---

*Lab built as part of IT Support & SysAdmin learning journey.*
