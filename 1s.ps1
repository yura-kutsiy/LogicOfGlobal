Enable-PSRemoting -Force
winrm qc -Force
Set-ExecutionPolicy RemoteSigned -Force
winrm set winrm/config/client '@{TrustedHosts="18.184.142.249"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client '@{AllowUnencrypted="true"}'
winrm set winrm/config/client/auth '@{Basic = "true"}'
$cred = Get-Credential
#Enter-PSSession -ComputerName 18.184.142.249 -Credential $cred -Authentication Basic
Invoke-Command -FilePath c:\s2.ps1 -ComputerName 18.184.142.249 -Credential $cred