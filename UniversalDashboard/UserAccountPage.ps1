
#User Table Begin        
$User_Props = @(

    'PwdLastSet',
    'LastBadPasswordAttempt',
    'PasswordExpired',
    'Department',
    'Division',
    'Description',
    'Office',
    'Title'
)

$User = Get-Aduser -Identity (Get-PSUCache -Key 'Username')  -Properties $User_Props

$props = [ordered]@{

    "Full"            = $User.Name
    "UserName"        = $User.SamaccountName
    "UPN"             = $User.UserPrincipalName
    "Department"      = $User.Department
    "Office"          = $User.Office
    "Title"           = $User.Title
    "Team"            = $User.Division
    "PasswordExpired" = $User.PasswordExpired


}

if ($Null -ne $User.LastBadPasswordAttempt) {
    $Props["LastBadPasswordAttempt"] = (Get-date $User.LastBadPasswordAttempt).DateTime
}


If ($User.pwdlastset -ne 0) {

    $Props["PwdLastSet"] = (Get-date $User.PwdLastSet).DateTime
}

$Data = , @($props.GetEnumerator())
$DateColumns = @(
    New-UDTableColumn -Property Name -Title " "  
    New-UDTableColumn -Property Value -Title " " 
)
#User Table End

# User Group Membership Table Begin
$Groups = Get-AdprincipalGroupMembership -Identity $cache:name | Sort Name | Select Name, SamAccountName, GroupCategory, DistinguishedName


$Props = foreach ($Group in $Groups) {
    $RealGroups = Get-adgroup $Group.Distinguishedname -Properties Description
    @{

        DisplayName       = $RealGroups.Name.tostring()
        GroupCategory     = $RealGroups.GroupCategory.tostring()
        SamAccountName    = $RealGroups.SamAccountName.tostring()
        DistinguishedName = $RealGroups.DistinguishedName.tostring()
        Description       = $RealGroups.Description

    } 
}

$Columns = @(
    New-UDTableColumn -Property DisplayName -Title "Display Name" -ShowSort -IncludeInExport -IncludeInSearch -ShowFilter -FilterType text -DefaultSortColumn
    New-UDTableColumn -Property GroupCategory -Title GroupCategory -ShowSort  -IncludeInExport -IncludeInSearch -ShowFilter -FilterType select
    New-UDTableColumn -Property SamAccountName -Title SamAccountName -IncludeInExport 
    New-UDTableColumn -Property Description -Title Description -IncludeInExport  
    New-UDTableColumn -Property DistinguishedName -Title DistinguishedName -IncludeInExport -Hidden
)

$TableSplat = @{
        
    ShowSelection  = $True
    ShowExport     = $True
    ShowSearch     = $True
    ShowPagination = $True
    PageSize       = 10
}

# User Membership Table End

New-UDGrid -Container -Children {


     New-UDGrid  -item -MediumSize 4 -Children {
    
    
        $Icon = New-UDIcon -Icon 'User' -Size sm -Solid 
        $Header = New-UDCardHeader -Title " "
        $Body = New-udcardbody -Content { New-UDTable -Data $Data[0] -Columns $DateColumns -Icon $Icon -Title "Account Information" }
        $Footer = New-UDCardFooter -Content { New-UDButton -Text "Back" -OnClick { Invoke-UDRedirect '/HomePage' } }
        New-UDCard -Header $Header -Body $Body -Footer $Footer 
    

    }

    New-UDGrid -item -Smallsize 8 -Children {

        $Icon2 = New-UDIcon -Icon 'Users' -Size sm -Solid 
        $Body2 = New-UDCardBody -Content {

            New-UDTable -Id 'Group_Table' -Data $Props -Columns $Columns -Title "Group Memberships"  @TableSplat -Icon $Icon2 -OnRowSelection {
            
                $Items = $EventData
            
          
            }
            New-UDButton -Text "Remove Selected Groups" -OnClick {
            
                Show-UDToast -Message (Get-PSUCache -Key 'Username')
                $Value = Get-UDElement -Id "Group_Table"
            
                $Confirm = Read-Host "Are you sure you want to remove the selected groups? Yes / No"

                If ($Confirm -like 'y*') {
                    foreach ($Item in $Value.selectedRows.distinguishedname) {

                        Remove-ADGroupMember -Identity $Item -Members (Get-PSUCache -Key 'Username') -Credential $Secret:COV 

                    }

                }

            
            }
            
            New-UDButton -Text ‘Refresh’ -OnClick {
                invoke-udredirect -url '/user-information'
            }
        

    

        } # UDCard Body 
    
        New-UDCard -Header $Header -Body $Body2 
    } #UD Grid items

        


} #UD Container
