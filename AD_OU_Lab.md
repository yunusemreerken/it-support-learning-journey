# Active Directory — Organizational Unit (OU) Lab

## Overview

A hands-on lab covering OU structure design, user/group management, and Group Policy Object (GPO) linking in a Windows Server Active Directory environment.

---

## Environment

| Component | Value |
|-----------|-------|
| Domain | `lab.local` |
| Domain Controller | `DC01.lab.local` |
| Client Machine | `WINDOWS-CLIENT` |
| OS | Windows Server + Windows 11 |

---

## OU Structure

```
lab.local
├── _Users
│   └── _IT
│       └── Ersoy (user account)
├── _Groups
│   ├── IT
│   ├── IT-Write
│   └── IT-ReadOnly
└── _Computers
    └── WINDOWS-CLIENT
```

> **Why the underscore prefix?**  
> Prefixing OU names with `_` keeps them at the top of the list in ADUC and visually separates them from built-in system containers like `CN=Users`.

---

## Key Concepts

### OU vs. Default Container

| | Default Container (CN=Users) | Organizational Unit (OU) |
|---|---|---|
| GPO can be linked | ✗ | ✓ |
| Delegation of control | ✗ | ✓ |
| Custom organization | Limited | Full |

> All user accounts and groups were initially created in `CN=Users`. They were moved to the correct OUs before applying GPO.

### OU vs. Group

| | OU | Security Group |
|---|---|---|
| Purpose | Organize objects, link GPO | Assign permissions |
| Visible in GPMC | ✓ | ✗ |
| NTFS permissions | ✗ | ✓ |

---

## RBAC Design

Three security groups were created to implement role-based access control:

| Group | Purpose | NTFS Permission |
|-------|---------|-----------------|
| `IT` | Parent group | — |
| `IT-Write` | Write access | Modify |
| `IT-ReadOnly` | Read-only access | Read & Execute |

### NTFS vs. Share Permission

Both layers apply simultaneously. The **more restrictive** permission wins.

| | NTFS Permission | Share Permission |
|---|---|---|
| Applied at | File system level | Network access level |
| Recommended practice | Set granular restrictions here | Set to `Everyone - Full Control`, control via NTFS |

---

## GPO Configuration

### GPO: `GPO_IT_Restrictions`

- **Linked to:** `OU=_IT,OU=_Users,DC=lab,DC=local`
- **Scope:** Applies to all user accounts inside `_IT` OU

#### Applied Policy

```
User Configuration
  → Policies
    → Administrative Templates
      → Control Panel
        → Prohibit access to Control Panel and PC settings
          → Enabled
```

**Result:** Users in `_IT` OU cannot open Control Panel.

---

## Commands Used

### PowerShell — OU Management

```powershell
# List all OUs
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName

# Create OU
New-ADOrganizationalUnit -Name "_IT" -Path "OU=_Users,DC=lab,DC=local"

# Verify user location
Get-ADUser -Identity Ersoy | Select-Object DistinguishedName

# Reset user password
Set-ADAccountPassword -Identity Ersoy -Reset -NewPassword (ConvertTo-SecureString "Passw0rd!" -AsPlainText -Force)

# Unlock account
Unlock-ADAccount -Identity Ersoy
```

### CMD — GPO

```cmd
# Force apply Group Policy
gpupdate /force

# Check applied GPOs for current user
gpresult /r
```

---

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| GPO not applied after change | Kerberos TGT cached old group membership | `gpupdate /force` + sign-out → sign-in |
| GPO applied to all users | GPO linked to domain root, not OU | Remove domain-level link, re-link to target OU |
| OU not visible in GPMC | Object is a Group, not an OU | Verify icon in ADUC — folder = OU, people = Group |
| "Already exists" on OU creation | Name conflict with existing object | Use prefix like `_IT` instead of `IT` |

---

## How Kerberos Relates

When a user logs on, Windows issues a **Kerberos TGT (Ticket Granting Ticket)** containing group memberships at that moment. If group membership or GPO changes while the session is active:

- `gpupdate /force` → refreshes policy settings
- **Sign-out required** → new TGT issued with updated memberships

This is why "it didn't work" until sign-out — the session was carrying a stale token.

---

## Result

After linking `GPO_IT_Restrictions` to `_IT` OU and running `gpupdate /force`:

> *"This operation has been cancelled due to restrictions in effect on this computer. Please contact your system administrator."*

GPO successfully applied. ✓
