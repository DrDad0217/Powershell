New-UDPage -Url "/GroupSearch" -Name "GroupSearch" -Content {
# Use Get-UDPage -Name 'GroupSearch' to use this page in your dashboard

$Group_Properties = @('Name','SamAccountName','GroupCategory','Description')

$Groups = Get-ADGroup -Filter 'Groupcategory -eq "Security" -or GroupCategory -eq "Distribution"' -SearchBase 'OU=City of Vancouver,DC=internal,DC=cityofvancouver,DC=us' -Properties Description | Select $Group_Properties

$Data = foreach($Group in $Groups){

@{
    Name           = $Group.Name
    SamAccountName = $Group.SamAccountName
    GroupCategory  = $Group.GroupCategory
    Description    = $Group.Description 

}


}

$Columns = @(

    New-UDTableColumn -Property Name -Title Name -IncludeInSearch -IncludeInExport -DefaultSortColumn 
    New-UDTableColumn -Property SamAccountName -Title SamAccountName -IncludeInSearch -IncludeInExport 
    New-UDTableColumn -Property GroupCategory -Title GroupCategory -IncludeInExport #-ShowFilter -FilterType Select
    New-UDTableColumn -Property Description -Title Description -IncludeInExport

)

$TableIcon = New-UDIcon -Icon 'Search' -Size lg -Bounce

# Create the UD card with the table and button together.
$Body = New-UDCardBody -Content {

New-UDTable -Id 'Group_Search_Table' -Data $Data -Columns $Columns -Icon $TableIcon -Title "Active Directory Groups" -ShowSort -ShowExport -ShowSelection -ShowFilter -ShowSearch -ShowPagination -PageSize 9 



New-UDButton -Text "Get Members" -OnClick {
    
    $Value = Get-UDElement -Id "Group_Search_Table"
    Set-PSUCache -Key 'GroupSearchSAM' -Value $Value.selectedrows.samaccountname
    Set-PSUCache -Key 'GroupSearchName' -Value $Value.selectedrows.Name
    Show-UDToast -message (Get-psucache -Key GroupSearchSAM)
    Invoke-UDRedirect 'GroupSearchMembers'
}
} 

New-UDcard -Body $Body
}