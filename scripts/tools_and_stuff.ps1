# add your customizations here in this script.
# e.g. install Chocolatey
if (Test-Path "$env:windir\explorer.exe") {
Invoke-Webrequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
}

Write-Host "Add sysprep script to c:\scripts to call when Packer performs a shutdown."
$SysprepCmd = @"
sc config winrm start=demand
C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:/Windows/Panther/Unattend/unattend.xml /quiet /shutdown
"@

Set-Content -path "C:\Scripts\sysprep.cmd" -Value $SysprepCmd
$SetupComplete = @"
cmd.exe /c sc config winrm start= auto
cmd.exe /c net start winrm
"@

New-Item -Path 'C:\Windows\Setup\Scripts' -ItemType Directory -Force
Set-Content -path "C:\Windows\Setup\Scripts\SetupComplete.cmd" -Value $SetupComplete

# rearm script to exend the trial
Write-Host "Add rearm script to desktop and c:\scripts to extend the trial."
$rearmCmd = @"
slmgr -rearm
pause
"@
Set-Content -path "C:\Scripts\extend-trial.cmd" -Value $RearmCmd
if (Test-Path "$env:windir\explorer.exe") {
  Set-Content -path "C:\Users\Vagrant\Desktop\extend-trial.cmd" -Value $RearmCmd
}

# Installing Guest Additions or Parallels tools
Wirte-Host "Installing 7-zip"
cinst 7zip -y 
Write-Host 'Installing Guest Additions or Parallels Tools'
if (-Not (Test-Path "$env:SYSTEMROOT\Temp\VBoxGuestAdditions.iso")) {
 Write-Host "Downloading"
 $virtualBoxVersion="6.1.10"
 (New-Object System.Net.WebClient).DownloadFile("http://download.virtualbox.org/virtualbox/$virtualBoxVersion/VBoxGuestAdditions_$virtualBoxVersion.iso", "$env:SYSTEMROOT\Temp\VBoxGuestAdditions.iso")
}
Write-Host "Unzip the ISO"
cmd /c "$env:ALLUSERSPROFILE\chocolatey\bin\7z.exe" x "$env:SYSTEMROOT\Temp\VBoxGuestAdditions.iso" "-o$env:SYSTEMROOT\Temp\virtualbox"
Write-Host "Install the cert"
cmd /c "$env:SYSTEMROOT\Temp\virtualbox\cert\VBoxCertUtil" add-trusted-publisher "$env:SYSTEMROOT\Temp\virtualbox\cert\vbox-sha1.cer" --root "$env:SYSTEMROOT\virtualbox\cert\vbox-sha1.cer"
cmd /c "$env:SYSTEMROOT\Temp\virtualbox\cert\VBoxCertUtil" add-trusted-publisher "$env:SYSTEMROOT\Temp\virtualbox\cert\vbox-sha256.cer" --root "$env:SYSTEMROOT\virtualbox\cert\vbox-sha256.cer"
cmd /c "$env:SYSTEMROOT\Temp\virtualbox\cert\VBoxCertUtil" add-trusted-publisher "$env:SYSTEMROOT\Temp\virtualbox\cert\vbox-sha256-r3.cer" --root "$env:SYSTEMROOT\virtualbox\cert\vbox-sha256-r3.cer"

Write-Host "Install the Guest Additions"
cmd /c "$env:SYSTEMROOT\Temp\virtualbox\VBoxWindowsAdditions.exe" /S /with_wddm /xres=1024 /yres=768
Write-Host "Clean up"
Remove-Item "$env:SYSTEMROOT\Temp\VBoxGuestAdditions.iso"
Remove-Item "$env:SYSTEMROOT\Temp\virtualbox\*" -recurse
