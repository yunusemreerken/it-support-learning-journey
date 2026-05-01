# GPO Lab Documentation — NordBank Scenario
**Environment:** Windows Server 2025 | Domain: `lab.local` | Client: Windows 11 (UTM on Mac)

---

## Lab Overview

A real-world Group Policy Object (GPO) lab simulating a mid-size bank environment with two branches (Istanbul HQ and Ankara Branch), built on Active Directory Domain Services.

---

## Active Directory Structure

```
lab.local
└── NordBank (OU)
     ├── Istanbul (OU)
     │    ├── Users (OU)
     │    │    ├── IT
     │    │    ├── Finance
     │    │    ├── HR
     │    │    ├── Management
     │    │    └── Tellers
     │    └── Computers (OU)
     │         ├── WorkStations
     │         └── Servers
     └── Ankara (OU)
          ├── Users (OU)
          │    ├── IT
          │    ├── Finance
          │    └── Tellers
          └── Computers (OU)
               └── WorkStations
```

---

## Users Created (via PowerShell)

| Full Name | Username | OU | Branch |
|-----------|----------|----|--------|
| Ali Yilmaz | a.yilmaz | IT | Istanbul |
| Ayse Kaya | a.kaya | IT | Istanbul |
| Mehmet Demir | m.demir | Finance | Istanbul |
| Fatma Celik | f.celik | Finance | Istanbul |
| Zeynep Arslan | z.arslan | HR | Istanbul |
| Kemal Ozturk | k.ozturk | Management | Istanbul |
| Selin Sahin | s.sahin | Tellers | Istanbul |
| Burak Yildiz | b.yildiz | Tellers | Istanbul |
| Can Ozdemir | c.ozdemir | IT | Ankara |
| Murat Akin | m.akin | Finance | Ankara |
| Elif Bulut | e.bulut | Tellers | Ankara |
| Hasan Koc | h.koc | Tellers | Ankara |

---

## GPO Policies Implemented

### 1. GPO-NB-Tellers-USB-Block
| Property | Value |
|----------|-------|
| **Linked OU** | `WorkStations` (Computer object location) |
| **Configuration** | Computer Configuration |
| **Path** | `Computer Configuration > Policies > Administrative Templates > System > Removable Storage Access` |
| **Settings** | All Removable Storage classes: Deny all access → Enabled |
| | Removable Disks: Deny read access → Enabled |
| | Removable Disks: Deny write access → Enabled |
| **Purpose** | Prevents data exfiltration via USB on teller workstations |

---

### 2. GPO-NB-Workstations-ScreenLock
| Property | Value |
|----------|-------|
| **Linked OU** | `Istanbul > Users` |
| **Configuration** | User Configuration |
| **Path** | `User Configuration > Policies > Administrative Templates > Control Panel > Personalization` |
| **Settings** | Enable screen saver → Enabled |
| | Screen saver timeout → 300 seconds (5 minutes) |
| | Password protect the screen saver → Enabled |
| **Purpose** | Enforces automatic screen lock — users cannot change this setting |

---

## Key Concepts Learned

### Computer Configuration vs User Configuration
| Type | Applied When | Linked To |
|------|-------------|-----------|
| Computer Configuration | Machine startup | OU where **computer object** lives |
| User Configuration | User login | OU where **user object** lives |

### GPO Processing Order (LSDOU)
```
Local → Site → Domain → OU
```
Last applied wins. Child OU GPOs override parent OU GPOs.

### Important Rules
- **Default Domain Policy** — never add custom policies here except Password Policy and Account Lockout
- **Containers** (like default `Computers`) cannot have GPOs linked — always move objects to OUs
- **Domain Admins** are not affected by most GPOs — always test with a standard user account
- **`gpupdate /force`** — forces immediate GPO refresh without waiting for next cycle

---

## Troubleshooting Commands

```powershell
# Check applied GPOs for current user
gpresult /scope user /r

# Check applied GPOs for computer
gpresult /scope computer /r

# Generate full HTML report
gpresult /h C:\GPOReport.html
start C:\GPOReport.html

# Force GPO refresh
gpupdate /force

# List all AD computers
Get-ADComputer -Filter * | Select-Object Name, DistinguishedName

# List all AD users
Get-ADUser -Filter * -Properties DistinguishedName | Select-Object Name, DistinguishedName
```

---

## Common Mistakes & Fixes

| Mistake | Fix |
|---------|-----|
| GPO not applying | Check if computer/user object is in the correct OU |
| Testing with Administrator account | Always test with a standard domain user |
| Running `gpresult` as Administrator | Run CMD normally (not as admin) for user GPO results |
| Computer object in default `Computers` container | Move to a proper OU — containers don't support GPO linking |
| Duplicate GPO links | Remove extra links via GPMC → OU → Linked GPOs → Delete Link |
| OU protected from accidental deletion | `dsa.msc → View → Advanced Features → Object tab → uncheck protection` |

---

## Environment

- **Server OS:** Windows Server 2025
- **Client OS:** Windows 11 (running on UTM / Apple Silicon Mac)
- **Domain:** lab.local
- **DC:** DC01.lab.local
- **Tools Used:** `gpmc.msc`, `dsa.msc`, `gpresult`, PowerShell

---

*Lab built as part of IT Support & SysAdmin learning journey.*
