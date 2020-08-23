Write-output "`n----------------------------------------------------------------------------------------"
Write-output "THIS SCRIPT WILL DELETE USER PROFILES ON THIS MACHINE THAT HAVE NOT BEEN ACCESSED SINCE:"
$date = [DateTime]::Now.AddDays(-5)
"{0:MM-dd-yyyy}" -f $date 
Write-output "----------------------------------------------------------------------------------------"

$DeletedProfiles = Get-CimInstance -ClassName Win32_UserProfile | where LocalPath -like "C:\Users\*" | where LocalPath -ne "C:\Users\noaccess" | where LastUseTime -le $date
$TodaysDate = Date

Write-output "----------------------------------------------------------" > DeletedProfiles.log
Write-output "THE FOLLOWING PROFILES WERE DELETED ON $TodaysDate" >> DeletedProfiles.log
Write-output "----------------------------------------------------------" >> DeletedProfiles.log
$DeletedProfiles >> DeletedProfiles.log

Get-CimInstance -ClassName Win32_UserProfile | where LocalPath -like "C:\Users\*" | where LocalPath -ne "C:\Users\noaccess" | where LastUseTime -le $date | remove-ciminstance -verbose

Write-output "------------------"
Write-output "LOGGING TO FILE..."
Write-output "------------------"