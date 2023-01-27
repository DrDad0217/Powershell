# Put code you'd like to run during dashboard startup here. 

New-UDDashboard -Title 'PowerShell Universal' -Pages @(
    # Create a page using the menu to the right ->   
    # Reference the page here with Get-UDPage
    New-UDPage -Name 'Home' -Content {

        $Columns = @(
    New-UDTableColumn -Property Name -Title "Name" -ShowFilter
    New-UDTableColumn -Property Value -Title "Value" -ShowFilter
)

$Data = 1..1000 | ForEach-Object {
  [PSCustomObject]@{
      Name = "Record-$_"
      Value = $_ 
  }
}

New-UDTable -Columns $Columns -LoadData {
    foreach($Filter in $EventData.Filters)
    {
        $Data = $Data | Where-Object -Property $Filter.Id -Match -Value $Filter.Value
    }

    $TotalCount = $Data.Count 

    if (-not [string]::IsNullOrEmpty($EventData.OrderBy.Field))
    {
        $Descending = $EventData.OrderDirection -ne 'asc'
        $Data = $Data | Sort-Object -Property ($EventData.orderBy.Field) -Descending:$Descending
    }
    
    $Data = $Data | Select-Object -First $EventData.PageSize -Skip ($EventData.Page * $EventData.PageSize)

    $Data | Out-UDTableData -Page $EventData.Page -TotalCount $TotalCount -Properties $EventData.Properties 
} -ShowFilter -ShowSort -ShowPagination
    }
)