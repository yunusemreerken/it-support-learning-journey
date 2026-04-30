# 🖥️ IT Lab — Windows Server 2025 Active Directory Lab

> **TR:** Sektöre hazırlanan IT Support profesyonelleri için Windows Server 2025 üzerinde Active Directory lab ortamı kurulum rehberi.
>
> **EN:** A hands-on Active Directory lab setup guide on Windows Server 2025 for aspiring IT Support professionals.

---

## 📐 Lab Architecture / Lab Mimarisi

```
┌─────────────────────────────────────────────────────────┐
│                     LAB.LOCAL DOMAIN                    │
│                                                         │
│   ┌─────────────────────┐     ┌─────────────────────┐  │
│   │   ASUS (Bare Metal) │     │  MacBook (UTM VM)   │  │
│   │                     │     │                     │  │
│   │  Windows Server     │◄───►│   Windows 11        │  │
│   │  2025               │     │   Client            │  │
│   │                     │     │                     │  │
│   │  DC01               │     │  Windows-Client     │  │
│   │  IP: 192.168.1.10   │     │  IP: 192.168.1.20   │  │
│   │  DNS: 127.0.0.1     │     │  DNS: 192.168.1.10  │  │
│   │                     │     │                     │  │
│   │  Roles:             │     │  Domain Member      │  │
│   │  ✅ AD DS           │     │  ✅ Joined to       │  │
│   │  ✅ DNS             │     │     lab.local        │  │
│   │  ✅ Domain Controller│    │                     │  │
│   └─────────────────────┘     └─────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 🛠️ Environment / Ortam

| Component | Detail |
|---|---|
| **DC / Server** | ASUS — Bare Metal |
| **OS (Server)** | Windows Server 2025 |
| **Client** | MacBook — UTM (Bridged Network) |
| **OS (Client)** | Windows 11 |
| **Domain** | lab.local |
| **DC Hostname** | DC01 |
| **DC IP** | 192.168.1.10 (Static) |
| **Client IP** | 192.168.1.20 (Static) |
| **Functional Level** | Windows Server 2025 |

---

## 🚀 Setup Steps / Kurulum Adımları

### Step 1 — Windows Server 2025 Clean Install / Temiz Kurulum

**EN:** Install Windows Server 2025 (Desktop Experience) on bare metal. During installation, set a strong password meeting complexity requirements.

**TR:** Bare metal makineye Windows Server 2025 (Desktop Experience) kurulumu yapılır. Kurulum sırasında complexity kurallarına uygun güçlü bir şifre belirlenir.

```
Password requirements / Şifre kuralları:
  ✅ Min 8 characters / En az 8 karakter
  ✅ Uppercase + Lowercase / Büyük + Küçük harf
  ✅ Number / Rakam
  ✅ Special character / Özel karakter
  Example / Örnek: Lab2025!
```

---

### Step 2 — Basic Configuration / Temel Ayarlar

**EN:** Set hostname and static IP before promoting to Domain Controller.

**TR:** Domain Controller'a promote etmeden önce hostname ve statik IP ayarlanır.

**Hostname:**
```
Server Manager → Local Server → Computer Name → Change → DC01
```

**Static IP / Statik IP:**
```
Network Adapter → Properties → IPv4:
  IP Address    : 192.168.1.10
  Subnet Mask   : 255.255.255.0
  Default Gateway: 192.168.1.1
  DNS Server    : 127.0.0.1
```

> ⚠️ **Reboot after both changes / Her iki değişiklikten sonra reboot yapın.**

---

### Step 3 — AD DS Role Installation / AD DS Rol Kurulumu

**EN:** Add the Active Directory Domain Services role via Server Manager.

**TR:** Server Manager üzerinden Active Directory Domain Services rolü eklenir.

```
Server Manager → Manage → Add Roles and Features
  → Role-based installation
  → Active Directory Domain Services ✅
  → Add Features → Install
```

> ⏳ **Wait ~5-10 min / ~5-10 dk bekleyin** 

---

### Step 4 — DC Promotion / DC Promotion

**EN:** After role installation, a yellow flag appears in Server Manager. Click "Promote this server to a domain controller."

**TR:** Rol kurulumu tamamlandıktan sonra Server Manager'da sarı bayrak belirir. "Promote this server to a domain controller" tıklanır.

```
Deployment Configuration:
  → Add a new forest
  → Root domain name: lab.local

Domain Controller Options:
  → Forest functional level: Windows Server 2025
  → Domain functional level: Windows Server 2025
  → DNS Server ✅
  → Global Catalog ✅
  → DSRM Password: Lab2025!

DNS Options:
  → Yellow warning → Normal, Next

Additional Options:
  → NetBIOS name: LAB (auto)

Paths:
  → Default → Next

→ Install
```

> ⏳ **Server reboots automatically / Sunucu otomatik reboot olur** 

**EN:** After reboot, login with `LAB\Administrator`

**TR:** Reboot sonrası `LAB\Administrator` ile giriş yapılır.

---

### Step 5 — Client Network Configuration / Client Ağ Ayarları

**EN:** On Windows 11 UTM VM, set network to Bridged mode and configure static IP with DC as DNS.

**TR:** Windows 11 UTM VM'de ağ modu Bridged olarak ayarlanır, statik IP ve DNS olarak DC adresi girilir.

**UTM Network Mode:**
```
UTM → Windows 11 VM → Settings → Network → Bridged (en0 for WiFi)
```

**Windows 11 IP Settings:**
```
Settings → Network → Ethernet → IPv4 → Manual:
  IP Address    : 192.168.1.20
  Subnet Mask   : 255.255.255.0
  Default Gateway: 192.168.1.1
  DNS Server    : 192.168.1.10  ← Critical! / Kritik!
```

---

### Step 6 — Domain Join / Domain'e Katılım

**EN:** Join the Windows 11 client to lab.local domain.

**TR:** Windows 11 client, lab.local domain'ine dahil edilir.

```
Start → sysdm.cpl → Computer Name → Change
  → Domain: lab.local
  → Username: Administrator
  → Password: Lab2025!
```

> ✅ "Welcome to lab.local" mesajı gelirse başarılı!

---

## ✅ Verification / Doğrulama

**On DC / DC'de:**
```powershell
# Check AD DS service
Get-Service adws, kdc, netlogon, dns

# Check domain
Get-ADDomain

# Check DC
Get-ADDomainController
```

**On Client / Client'ta:**
```powershell
# Check domain join
systeminfo | findstr /i "domain"

# Ping DC
ping 192.168.1.10

# Test DNS
nslookup lab.local
```

---

## 📚 Next Steps / Sonraki Adımlar

| Topic | Description |
|---|---|
| **User & Group Management** | AD'de kullanıcı ve grup oluşturma |
| **Organizational Units (OU)** | Departman bazlı yapı kurma |
| **Group Policy (GPO)** | Merkezi politika yönetimi |
| **Password Policies** | Şifre kuralları tanımlama |
| **File Server** | Paylaşım ve yetki yönetimi |
| **DHCP** | Otomatik IP dağıtımı |
| **RSAT** | MacBook'tan uzak yönetim |

---

## 🗺️ Career Path / Kariyer Yolu

```
SAM (Local Accounts)
     ↓
AD DS / Domain Management  ← 📍 You are here / Buradasınız
     ↓
Azure AD / Entra ID (Hybrid)
     ↓
IAM (Cloud Identity Management)
     ↓
PAM (Privileged Access Management)
```

---

## 📝 Notes / Notlar

- **TR:** Bu lab ortamı IT Support pozisyonlarına hazırlık amacıyla kurulmuştur. Tüm adımlar gerçek kurumsal ortamları simüle etmektedir.
- **EN:** This lab environment is built for IT Support career preparation. All steps simulate real enterprise environments.
- UTM Bridged mode required for VM-to-DC communication / VM ile DC iletişimi için UTM Bridged modu gereklidir.
- DSRM password must be noted separately / DSRM şifresi ayrıca not edilmelidir.

---

## 👤 Author / Yazar

> IT Support — Sektöre Hazırlık / Career Preparation
>
> Lab completed in ~1 hour / Lab ~1 saatte tamamlandı ✅
