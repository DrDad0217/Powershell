$Nav = New-UDList -Content {
    New-UDListItem -Label "Home" -OnClick { Invoke-UDRedirect '/home' } -Icon (New-UDIcon -Icon Home -Size 1x)
    New-UDListItem -Label "Settings" -OnClick { Invoke-UDRedirect '/settings' } -Icon (New-UDIcon -Icon Cog -Size 1x)
    New-UDListItem -Label "Documentation" -OnClick { Invoke-UDRedirect 'https://docs.powershelluniversal.com' } -Icon (New-UDIcon -Icon Book -Size 1x)
}

New-UDDashboard -Title 'Navigation' -Pages @(
    New-UDPage -Name 'Home' -Content {
        New-UDTypography -Text 'Home'
    }  
    New-UDPage -Name 'Settings' -Content {
        New-UDTypography -Text 'Settings'
    } 
) -Navigation $Nav
