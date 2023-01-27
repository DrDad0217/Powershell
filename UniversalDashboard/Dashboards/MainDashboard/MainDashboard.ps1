$Nav = New-UDList -Content {
    New-UDListItem -Label "Home" -OnClick { Invoke-UDRedirect '/home' } -Icon (New-UDIcon -Icon Home -Size 1x)
    #New-UDListItem -Label "UserAD" -OnClick { Invoke-UDRedirect '/UserAD' } -Icon (New-UDIcon -Icon Cog -Size 1x) -
 
}

New-UDDashboard -Title 'Navigation' -Pages @(
    New-UDPage -Name 'Home' -Content {
        #New-UDImage -Path 'C:\users\schmidtt\Downloads\icons8-fire.ico'
        
        $UserBoxHeader = New-UDCardHeader -Title "Active Directory User Search"
        $UserBox = New-UDCardBody -Content {

            New-UDTextbox -Id 'UserName' -Label 'UserName' 
            New-UDButton -OnClick {
            $Cache:name = (Get-UDElement -Id 'UserName').value 
      
                Invoke-UDRedirect '/UserAD'
      
            } -Text "Search" 
        } # User box 


        $GroupBoxHeader = New-UDCardHeader -Title "Active Directory Group Search"
        $GroupBox = New-UDCardBody -Content {

            New-UDTextbox -Id 'GroupName' -Label 'GroupName' 
            New-UDButton -OnClick {
                $Cache:Group = (Get-UDElement -Id 'GroupName').value 
      
                Invoke-UDRedirect '/GroupAD'
      
            } -Text "Search" 
        } # User box 
        
        
        New-UDLayout -Columns 3 -Content {

            New-UDCard -Body $UserBox -Header $UserBoxHeader
            New-UDCard -Body $GroupBox -Header $GroupBoxHeader

        } # Home Page Layout
        
     
    } # Home Page Content 
    
    New-UDPage -HeaderBackgroundColor  'Crimson' -Name 'UserAD' -Content {
          
        $AccountInfo = New-UDCardBody -Content { Invoke-RestMethod http://localhost:5000/AD/UserAccountInformation -Method GET }
        $GroupInfo = New-UDCardBody -Content { Invoke-RestMethod http://localhost:5000/AD/UserGroups -Method GET }
        $PassInfo = New-UDCardBody -Content { Invoke-RestMethod http://localhost:5000/AD/PassInfo -Method GET }
        $CompanyInfo = New-UDCardBody -Content { Invoke-RestMethod http://localhost:5000/AD/CompanyInfo -Method GET }
        $TestTable = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/RandomHashTable -Method GET}

        New-UDGrid -Container -Children{

            New-UDGrid -item -MediumSize 5 -Children {
            
            New-Udcard -Body $TestTable
            #New-UDcard -Body $AccountInfo            
            #New-UDCard -Body $CompanyInfo
          


            }
            

            New-UDGrid -item -MediumSize 7 -Children {
            
            New-UDcard -Body $GroupInfo   
            #New-UDcard -Body $AccountInfo            
            #New-UDCard -Body $CompanyInfo

            }
            
        }
        <#
    4
        New-UDLayout -Columns 2 -Content {
             
            New-UDcard -Body $GroupInfo
            New-UDcard -Body $AccountInfo 
            New-UDCard -Body $CompanyInfo
            #New-UDCard -Body $PassInfo

        }

        #>
        New-UDButton -Text "Hello" -OnClick{
            
            $Value = Get-UDElement -Id "Member_Table"
            $Cache:Group = $Value.SelectedRows.Name
            $Cache:GroupDisplayName = $value.SelectedRows.DisplayName
            Invoke-UDRedirect '/GroupMembers'

        }


    } # User Page 

    New-UDPage -HeaderBackgroundColor 'Crimson' -Name 'GroupAD' -Content {
          
        $ADGroupInfo = New-UDCardBody -Content { Invoke-RestMethod http://localhost:5000/AD/GroupInfo -Method GET }

        New-UDLayout -Columns 2 -Content {

            New-UDCard -Body $ADGroupInfo
        }


    }

    New-UDPage -HeaderBackgroundColor Crimson -Name 'GroupSearch' -Content {

        Invoke-RestMethod http://localhost:5000/AD/GroupSearch -Method GET
       New-UDButton -Text "Get Members" -OnClick {
            
            $Value = Get-UDElement -Id "Group_Table"
            $Cache:Group = $Value.SelectedRows.SamAccountName
            $Cache:GroupDisplayName = $value.SelectedRows.DisplayName
            Invoke-UDRedirect '/GroupMembers'
           
        }
        
    }

    <#
    New-UDPage  -HeaderBackgroundColor Crimson -Name 'GroupMembers' -Content {

        $MemberData = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/AD/GroupInfo -Method GET}

        New-UDLayout -Columns 2 -Content {

        New-UDCard -Body $MemberData 

        }
    }

    #>

    ) 








