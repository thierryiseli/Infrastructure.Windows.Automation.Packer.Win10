Write-Host "Enabling RDP, reset SysprepStatus and show file extensions"

netsh advfirewall firewall add rule name="Remote Desktop" dir=in localport=3389 protocol=TCP action=allow
reg add 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server' /v fDenyTSConnections /t REG_DWORD /d 0 /f
Set-ItemProperty -Path 'HKLM:\SYSTEM\Setup\Status\SysprepStatus'  -Name  'GeneralizationState' -Value 7
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\UnattendBackup\ActiveSetup\DisableFirstRunWizard" -Name DisableFirstRunWizard -Value 1
Set-ItemProperty -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 1