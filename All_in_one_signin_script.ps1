<#
Note:
The text prefix "cc" is added to all Security & Compliance Center cmdlet names so you can run cmdlets that exist in both Exchange Online and the Security & Compliance Center in the same Windows PowerShell session. For example, Get-RoleGroup becomes Get-ccRoleGroupin the Security & Compliance Center.

Using an MFA enabled account:
If you run into errors when importing the Security & Compliance PowerShell session, you may need to install the Exchange PowerShell module that supports MFA authentications and use "Connect-IPPSession".
Reference link:
https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/mfa-connect-to-scc-powershell?view=exchange-ps

####
PreRequisites Modules: 

You will need to install the modules that are required for Office 365 (Sign-in Assistant), SharePoint Online, and Skype for Business Online:
https://www.microsoft.com/en-us/download/details.aspx?id=41950
https://www.microsoft.com/en-us/download/details.aspx?id=35588
https://www.microsoft.com/en-us/download/details.aspx?id=39366
#>

function CheckModuleMSOL {
    Write-Host "`n"
    Write-Host "Checking for MSOnline Module..."
    if (Get-Module -ListAvailable | ? {$_.name -eq "MSonline"}) {
        Write-Host "MSOnline Module is already installed. Importing..." 
        Import-Module MSOnline
        Write-Host "Done!"
    }
    else {
        Write-Host "MSOnline Module is not installed. Installing..."
        Install-Module MSOnline
        Import-Module MSOnline
        Write-Host "Done!"
    }
}

function CheckModuleSPO {
    Write-Host "`n"
    Write-Host "Checking for SharePoint Online Module..."
    if (Get-Module -ListAvailable | ? {$_.name -eq "Microsoft.Online.SharePoint.PowerShell"}) {
        Write-Host "SharePoint Online Module is already installed. Importing..." 
        Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
        Write-Host "Done!"
    }
    else {
        Write-Host "SharePoint Online Module is not installed. Installing..."
        Install-Module Microsoft.Online.SharePoint.PowerShell
        Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
        Write-Host "Done!"
    }
}

function CheckModuleSFB {
    Write-Host "`n"
    Write-Host "Checking for Skype for Business Online Module..."
    if (Get-Module -ListAvailable | ? {$_.name -eq "SkypeOnlineConnector"}) {
        Write-Host "Skype for Business Online Module is already installed. Importing..."
        Import-Module SkypeOnlineConnector
    }
    else{
        Write-Host "Skype for Business Online Module is not installed. Installing..."
        Install-Module SkypeOnlineConnector
        Import-Module SkypeOnlineConnector
        Write-Host "Done!"
    }
}

function Connect-All {
    CheckModuleMSOL
    CheckModuleSPO
    CheckModuleSFB
    Connect-MsolService -Credential $credential
    Connect-SPOService -Url $url -credential $credential
    $sfboSession = New-CsOnlineSession -Credential $credential
    Import-PSSession $sfboSession
    $exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
    Import-PSSession $exchangeSession -DisableNameChecking
    $ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
    Import-PSSession $ccSession -Prefix cc
}

#Script starts here
$WindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$WindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($WindowsID)
$AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if ($WindowsPrincipal.IsInRole($AdminRole))
{
    Read-Host "Before running this script please ensure you have the prerequisite PowerShell modules installed. Reference links can be found at line 13 of this script.`nTo continue press any key."
    $url = Read-Host "Please provide the URL for SharePoint Online. (example syntax: "https://tenantnameco-admin.sharepoint.com")"
    Write-Host "Thank you. `nWhen prompted, please enter your O365 Global Admin credentials."
    Start-Sleep -s 5
    $credential = Get-Credential
    Connect-All
    Clear-Host
    Write-Host "You are now connected to O365, Exchange Online, Security & Compliance, SharePoint Online, and Skype for Business within one PowerShell window.`nTo differeniate between Exchange Online and Security & Compliance PowerShell cmdlets, please use the 'cc' prefix. (example: Exchange uses: "Search-UnifiedAuditLog" and Security & Compliance uses: "Search-ccUnifiedAuditLog")."
}
else {
    Write-Host "`nPlease run this script in an elevated PowerShell window."
}