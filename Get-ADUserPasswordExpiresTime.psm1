<#
.SYNOPSIS
Get-ADUserPasswordExpiresTime will query AD for the expiration time for one or more users. 
.DESCRIPTION
.PARAMETER
.EXAMPLE
Get-ADUserPassExpires.psm1 -SamAccountName DDuck
#>

function Get-CybADUserPasswordExpiresTime {
    [CmdletBinding()]
    #^ Optional ..Binding(SupportShouldProcess=$True,ConfirmImpact='Low')
    param (
    [Parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True)]
    [string[]]$SamAccountName,

    [Parameter(ValueFromPipelineByPropertyName=$True)]
    [string]$Server
    )

BEGIN {
    # Intentionaly left empty.
    # Provides optional one-time pre-processing for the function.
    # Setup tasks such as opening database connections, setting up log files, or initializing arrays.
}

PROCESS {
    foreach($Account in $SamAccountName){
        Get-ADUser -identity $Account -Server $Server -Properties SamAccountName,DisplayName,PasswordLastSet,PasswordNeverExpires,"msDS-UserPasswordExpiryTimeComputed" |
            Select-Object -Property SamAccountName,DisplayName,PasswordLastSet,PasswordNeverExpires,
            @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
    }
}


END {
    # Intentionaly left empty.
    # This block is used to provide one-time post-processing for the function.
}

} #Function