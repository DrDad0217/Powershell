
$UserBoxHeader = New-UDCardHeader -Title "Active Directory User Search"
        $UserBox = New-UDCardBody -Content {

            New-UDTextbox -Id 'UserName' -Label 'UserName' 
            New-UDButton -OnClick {
            Set-PSUCache -Key 'Username' -Value (Get-UDElement -Id 'UserName').value     
            $Cache:name = (Get-UDElement -Id 'UserName').value 
      
                Invoke-UDRedirect '/User-Information'
      
            } -Text "Search" 
        } # User box 

        New-UDLayout -Columns 3 -Content {

            New-UDCard -Header $UserBoxHeader -Body $UserBox
        }
