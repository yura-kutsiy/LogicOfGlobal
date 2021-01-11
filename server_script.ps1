<powershell>
Enable-PSRemoting -Force
winrm qc -Force
Set-ExecutionPolicy RemoteSigned -Force
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
md c:\website_directory
md c:\app_directory
Install-WindowsFeature –name Web-Server -IncludeManagementTools
</powershell>
