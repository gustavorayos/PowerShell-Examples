# Written By: Gustavo Rayos
# Date: June 01, 2017
# Description: Used to reset UPM profiles
# Requirements: Must be ran with your admin account


$username_Input = Read-Host -Prompt "`nPlease enter the username of the UPM profile you would like to reset"
$FoundFlag = 0

for($i = 1; $i -le 9; $i++){
    $StringI = [String]$i
    $ChkFile = ""
    $ChkFile = "\\raynetuser\User01-0" + $StringI + "\" + $username_Input
    $FileExists = Test-Path $ChkFile
    If ($FileExists -eq $true) {
        $FoundFlag = 1
        Write-Host "`nResetting UPM profile for $username_Input..."
        #$TodaysDate = date -Format d
        $OldUPMProfile = ""
        $OldUPMProfile = $ChkFile + "\Profile\xa_profile5.2.1"
        #$NewUPMProfile = "xa_profile5.2.1_" + $TodaysDate
        $CheckOldUPMProfile = Test-Path $OldUPMProfile
        
        If ($CheckOldUPMProfile -eq $true) {
            Remove-Item $OldUPMProfile -Recurse -Force
            Write-Host "UPM profile for $username_Input was reset."
        } #end of inner if
        else {
            Write-Host $OldUPMProfile
            Write-Host "UPM profile for $username_Input does not exist. Cannot be reset because it's not there."
        } #end of else
    } #end of outer if
} #end of for loop

if ($FoundFlag -eq 0) {
    Write-Host "`n$username_Input was not found. Please make sure it is spelt correctly."
} #end of if
