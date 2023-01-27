#API's to call information for tables
$UserAcctTable = New-UDCardBody -Content { Invoke-RestMethod http://localhost:5000/AD/UserAccountInformation -Method GET }
$UserAccs = New-UDCardheader -Title "User Account Information" -TitleAlignment left 


$Theme = Get-UDTheme -Name 'Atom'

$Nav = New-UDList -Content {
    New-UDListitem -Label "Home" -OnClick { Invoke-UDRedirect '/home' } -Icon (New-UDIcon -Icon Home -Size 1x)
 
}

New-UDDashboard -Theme $Theme  -Title 'PowerShell Universal' -Pages @(
   
    New-UDPage -Name 'Home' -Content {

        $UserBoxHeader = New-UDCardHeader -Title "Active Directory User Search"
        $UserBox = New-UDCardBody -Content {

            New-UDTextbox -Id 'UserName' -Label 'UserName' 
            New-UDButton -OnClick {
                $Cache:name = (Get-UDElement -Id 'UserName').value 
      
                Invoke-UDRedirect '/User-Information'
      
            } -Text "Search" 
        } # User box 

        New-UDLayout -Columns 3 -Content {

            New-UDCard -Header $UserBoxHeader -Body $UserBox
        }

                

    } #Home Page

    New-UDPage -Name 'User-Information' -Content {

        #User Table Begin        
        $User_Props = @(

            'PwdLastSet',
            'LastBadPasswordAttempt',
            'PasswordExpired',
            'Department',
            'Division',
            'Description',
            'Office'
        )

        $User = Get-Aduser -Identity $cache:name  -Properties $User_Props

        $props = [ordered]@{
    
            "Full"                   = $User.Name
            "UserName"               = $User.SamaccountName
            "UPN"                    = $User.UserPrincipalName
            "Department"             = $User.Department
            "Division"               = $User.Division
            "Description"            = $User.Description
            "Office"                 = $User.Office
            "PwdLastSet"             = (Get-date $User.PwdLastSet).ToString()
            "LastBadPasswordAttempt" = $User.LastBadPasswordAttempt.tostring()
            "PasswordExpired"        = $User.PasswordExpired
    

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
                
                $Icon = New-UDIcon -Icon 'User'
                $Header = New-UDCardHeader -Title " "
                $Body = New-udcardbody -Content { New-UDTable -Data $Data[0] -Columns $DateColumns -Icon $Icon -Title "Account Information" }
                $Footer = New-UDCardFooter -Content { New-UDButton -Text "Back" -OnClick { Invoke-UDRedirect '/Home' } }
                New-UDCard -Header $Header -Body $Body -Footer $Footer 
                
  
            }

            New-UDGrid -item -Smallsize 8 -Children {

                $Icon2 = New-UDIcon -Icon 'Users'
                $Body2 = New-UDCardBody -Content {

                    New-UDTable -Id 'Group_Table' -Data $Props -Columns $Columns -Title "Group Memberships"  @TableSplat -Icon $Icon2 -OnRowSelection {
                        
                        $Items = $EventData
                        #Show-UDToast -Message $items.displayname
                        Show-UDToast -Message "$($items.Distinguishedname | out-string)"
                        #Show-UDToast -Message $Cache:name
                    }
                    New-UDButton -Text "Remove Selected Groups" -OnClick {
                        
                        Show-UDToast -Message $cache:name
                        $Value = Get-UDElement -Id "Group_Table"

                        Show-UDToast -Message "$( $Value.selectedRows.distinguishedname | Out-String )"

                        $Confirm = Read-host "Confirm Group Removal? Yes \ No"

                        If ($confirm -match 'y') { foreach ($Item in $value) { Remove-ADGroupMember -Identity $value.selectedRows.distinguishedname.tostring() -Members $cache:name.ToString() } }
                    }
                    

                

                } # UDCard Body 
                
                New-UDCard -Header $Header -Body $Body2 
            } #UD Grid items

                    


        } #UD Container
    } # User-Information Page



) -Navigation $Nav















