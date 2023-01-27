New-UDPage -Url "/GroupSearchMembers" -Name "GroupSearchMembers" -Content {
#Pull members from cached samaccountname value from the group search page
$MemberData = Get-ADGroupMember -Identity (Get-PSUcache -Key GroupSearchSAM) | Select Name, SamAccountName

$GroupData = Get-ADGroup -Identity (Get-PSUcache -Key GroupSearchSAM) -Properties Description 

$GroupProperties = [Ordered]@{
    
    Name           = $GroupData.Name
    SamAccountName = $GroupData.SamAccountName
    GroupCategory  = $GroupData.GroupCategory
    Description    = $Groupdata.Description
    SID            = $Groupdata.Sid

}

$Data = , @($GroupProperties.GetEnumerator())
$DateColumns = @(
    New-UDTableColumn -Property Name -Title " "  
    New-UDTableColumn -Property Value -Title " " 
)

New-UDGrid -Container -Children {

    New-UDGrid -Item -Children {

        $Body = New-UDCardBody -Content { New-UDTable -Data $Data[0] -Columns $DateColumns -Title (Get-PSUcache -Key GroupSearchName) }
        New-UDCard -Body $Body

        $Body2 = New-UDCardBody -Content { New-UDTable -Data $MemberData -ShowPagination -PageSize 10 -Title "Members" -ShowSelection }

        New-Udcard -Body $Body2
    
    } # UDGrid Item

} # Grid Container
}