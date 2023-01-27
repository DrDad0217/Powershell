# Put code you'd like to run during dashboard startup here. 
$Theme = Get-UDTheme -Name 'Atom'
New-UDDashboard -Theme $Theme -Title 'PowerShell Universal' -Pages @(
    # Create a page using the menu to the right ->   
    # Reference the page here with Get-UDPage
    New-UDPage  -Name 'UserAD' -Content {
          
        $TestTable4 = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/TestTable03 -Method GET}
        $TestTable12 = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/RandomHashTable -Method GET}
        $TestTable = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/TestTable02 -Method GET}
        $TestTable6 = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/TestTable04 -Method GET}
        $PassTable = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/PassTable -Method GET}
        $UserAcctTable = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/UserAcctTable -Method GET}
        $CompanyTable = New-UDCardBody -Content {Invoke-RestMethod http://localhost:5000/Testing/CompanyTable -Method GET}
        
        New-UDGrid -Container -Children{

            

            New-UDGrid -item -Children {

                $UserAccs = New-UDCardheader -Title "User Account Information" -TitleAlignment left 

                $Icon = New-UDIcon -Icon 'user'
                
                
            New-UDCard -Body $UserAcctTable -Style @{width = 400; height = 250;} 
            New-UDCard -Body $CompanyTable -Style @{width = 400;}
            New-UDCard -Body $PassTable -Style @{width = 400; height = 250;}
            #New-UDCard -Body $TestTable  -Style @{width = 400; height = 250;}

  
    }

    New-UDGrid -item -MediumSize 8  -Children {
            
            

            New-Udcard  -Body $TestTable12 


             
            #-Style @{width = 800; height = 800;}


            }
        
            
            # New-Udcard -Style @{width = 400; height = 250;} -Body $TestTable4 
            # New-Udcard -Style @{width = 400; height = 250;} -Body $TestTable4
            # New-Udcard -Style @{width = 400; height = 250;} -Body $TestTable4
             }
            
            
            
            
            
            
            
        }
    
)








