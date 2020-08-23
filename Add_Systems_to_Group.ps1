# Author: Gustavo Rayos
# Date: April 10, 2017
  
<#    

    .DESCRIPTION    
        Adds a list of machines to an AD group from a CSV file    
    .PARAMETER  code    
        Specify group in which you want to add computers to by finding the Distinguished Name for the group in AD.
        Distinguished name of group is found by right clicking the group in AD, and then selecting the attributes tab.
        Has to be run with SVR account on OneNet domain machine.
     
#>    

$AD_Distinguished_Name = 'CN=App.WinZip,OU=SoftwareDistribution,OU=Secure,OU=Groups,OU=raynet,DC=raynet,DC=home,DC=cave,DC=com'

Get-Content Systems.csv | ForEach-Object {Get-QADComputer $_| Add-QADGroupMember $AD_Distinguished_Name}