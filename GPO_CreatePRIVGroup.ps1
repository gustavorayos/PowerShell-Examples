#Define requirements for input parameter $Action
Param(
	[Parameter(Mandatory=$true, Position=1)]
	[string]$HostName,

    [Parameter(Mandatory=$true, Position=2)]
    [string]$UserID
)

$LDAPPath = "LDAP://DC=raynet,DC=home,DC=cave,DC=com"
$proceed = $false
$aDGroupPrefix = "PermWksAdmin_"
$HostName = $HostName.ToUpper()
$groupPath = "OU=Workstation Admins,OU=Secure,OU=Groups,OU=raynet,DC=raynet,DC=home,DC=cave,DC=com"

Function ValidateObject($object,$type)
{	
	#This Function is used varify the object exsit.If object exists,it returns true ,otherwise returns false.
	$seek = [System.DirectoryServices.DirectorySearcher]$LDAPPath
	$seek.Filter = “(&(name=$object)(objectCategory=$type))”
	$Result = $seek.FindOne()
	IF( $Result -eq $null)
	{
		Return $false
	}
	Else 
	{	
		Return $true
	}
}

Function ValidateUser($UID)
{
    $User = Get-ADUser -Filter {sAMAccountName -eq $UID}
    If(($User -eq $Null) -or (($User.DistinguishedName).EndsWith("OU=Standard,OU=Users,OU=raynet,DC=raynet,DC=home,DC=cave,DC=com"))){
        Return $false
    }
    Else{
        Return $true
    }
}

If(ValidateUser $UserID)
{
    "User is good"
    If(ValidateObject $HostName "Computer")
    {
        "Computer is good"
        $proceed = $true
    }
    Else{"Computer name is invalid"}
}
Else{"UserID is invalid, make sure you provided a PRIV account"}


If($proceed)
{
    #Create group if doesn't already exist and append user
    $FullGroupName = $aDGroupPrefix + $HostName
    $FullGroupName
    If(ValidateObject $FullGroupName "Group")
    {
        "Group exists"
        "Adding $UserID to group $FullGroupName"
        Add-ADGroupMember -Identity $FullGroupName -Members $UserID
        "Adding computer to group WKS_LocalAdminExceptions to get the GPO"
        Add-ADGroupMember -Identity "WKS_LocalAdminExceptions" -Members (Get-ADComputer $HostName)
    }
    Else
    {
        "Group doesn't exist"
        "Creating AD group $FullGroupName"
        New-ADGroup -Name $FullGroupName -GroupCategory Security -GroupScope DomainLocal -Description "Local administrators on $HostName" -Path $groupPath
        "Adding $UserID to group $FullGroupName"
        Add-ADGroupMember -Identity $FullGroupName -Members $UserID
        "Adding computer to group WKS_LocalAdminExceptions to get the GPO"
        Add-ADGroupMember -Identity "WKS_LocalAdminExceptions" -Members (Get-ADComputer $HostName)

    }
}
