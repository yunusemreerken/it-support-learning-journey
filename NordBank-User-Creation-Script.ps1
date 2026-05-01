# NordBank User Creation Script
# Domain: lab.local

$domain = "DC=lab,DC=local"
$password = ConvertTo-SecureString "NordBank2025!" -AsPlainText -Force

$users = @(
    # Istanbul - IT
    @{Name="Ali Yilmaz";     SamAccount="a.yilmaz";   OU="OU=IT,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    @{Name="Ayse Kaya";      SamAccount="a.kaya";      OU="OU=IT,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    
    # Istanbul - Finance
    @{Name="Mehmet Demir";   SamAccount="m.demir";     OU="OU=Finance,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    @{Name="Fatma Celik";    SamAccount="f.celik";     OU="OU=Finance,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    
    # Istanbul - HR
    @{Name="Zeynep Arslan";  SamAccount="z.arslan";    OU="OU=HR,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    
    # Istanbul - Management
    @{Name="Kemal Ozturk";   SamAccount="k.ozturk";    OU="OU=Management,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    
    # Istanbul - Tellers
    @{Name="Selin Sahin";    SamAccount="s.sahin";     OU="OU=Tellers,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    @{Name="Burak Yildiz";   SamAccount="b.yildiz";    OU="OU=Tellers,OU=Users,OU=Istanbul,OU=NordBank,$domain"},
    
    # Ankara - IT
    @{Name="Can Ozdemir";    SamAccount="c.ozdemir";   OU="OU=IT,OU=Users,OU=Ankara,OU=NordBank,$domain"},
    
    # Ankara - Finance
    @{Name="Murat Akin";     SamAccount="m.akin";      OU="OU=Finance,OU=Users,OU=Ankara,OU=NordBank,$domain"},
    
    # Ankara - Tellers
    @{Name="Elif Bulut";     SamAccount="e.bulut";     OU="OU=Tellers,OU=Users,OU=Ankara,OU=NordBank,$domain"},
    @{Name="Hasan Koc";      SamAccount="h.koc";       OU="OU=Tellers,OU=Users,OU=Ankara,OU=NordBank,$domain"}
)

foreach ($user in $users) {
    $given  = $user.Name.Split(" ")[0]
    $surname = $user.Name.Split(" ")[1]
    
    New-ADUser `
        -Name              $user.Name `
        -GivenName         $given `
        -Surname           $surname `
        -SamAccountName    $user.SamAccount `
        -UserPrincipalName "$($user.SamAccount)@lab.local" `
        -Path              $user.OU `
        -AccountPassword   $password `
        -Enabled           $true `
        -PasswordNeverExpires $true

    Write-Host "✅ Oluşturuldu: $($user.Name) → $($user.OU.Split(',')[1].Replace('OU=',''))" 
}

Write-Host "`n🎉 Tüm kullanıcılar oluşturuldu!" -ForegroundColor Green