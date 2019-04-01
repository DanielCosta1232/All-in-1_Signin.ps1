### All_in_one_signin_script.ps1:
This script will sign into the following workloads all within one PowerShell window. 

O365
Exchange Online
SharePoint Online
Skype for Business

Ensure that all prequisites are installed prior to running the script. 

# Prerequisite Modules: 
You will need to install the modules that are required for Office 365 (Sign-in Assistant), SharePoint Online, and Skype for Business Online:

https://www.microsoft.com/en-us/download/details.aspx?id=41950

https://www.microsoft.com/en-us/download/details.aspx?id=35588

https://www.microsoft.com/en-us/download/details.aspx?id=39366


# Additional Notes:
The text prefix "cc" is added to all Security & Compliance Center cmdlet names so you can run cmdlets that exist in both Exchange Online and the Security & Compliance Center in the same Windows PowerShell session. For example, Get-RoleGroup becomes Get-ccRoleGroupin the Security & Compliance Center.

# Using an MFA enabled account
If you run into errors when importing the Security & Compliance PowerShell session, you may need to install the Exchange PowerShell module that supports MFA authentications and use "Connect-IPPSession".
Reference link:
https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/mfa-connect-to-scc-powershell?view=exchange-ps
