$Theme = Get-UDtheme -name 'Atom'
$Nav = New-UDList -Content {
    New-UDListitem -Label "HomePage" -OnClick { Invoke-UDRedirect '/HomePage' } -Icon (New-UDIcon -Icon Home -Size 1x)
    New-UDListitem -Label "Active Directory Group Search" -OnClick { Invoke-UDRedirect '/GroupSearch' } -Icon (New-UDIcon -Icon SearchLocation -Size 1x)
 
}
New-UDDashboard -Theme $Theme -Title 'PowerShell Universal' -Pages @(
    # Create a page using the menu to the right ->   
    # Reference the page here with Get-UDPage

Get-UDPage -Name 'Home Page'
Get-UDPage -Name 'User Account Information And Group Memberships'
Get-UDPage -Name 'GroupSearch'
Get-UDPage -Name 'GroupSearchMembers'





) -Navigation $Nav