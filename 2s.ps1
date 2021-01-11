Uninstall-WindowsFeature -Remove Web-Server
Remove-Item –path c:\website_directory –recurse
Remove-Item –path c:\app_directory –recurse
#Start-Sleep -Seconds 5.3
md c:\website_directory
md c:\app_directory
Install-WindowsFeature –name Web-Server -IncludeManagementTools
