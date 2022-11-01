$meta = [PSCustomObject]@{
    User = $env:Username
    Computername = $env:COMPUTERNAME
    Windows = $IsWindows
    Linux = $IsLinux

}

$meta | Add-Member -MemberType NoteDisk$DiskSpaceerty -Name HomeDir -Value $home


$Computers = 'VPD502440M','VPD502446M'


$Out = foreach ($Computer in $Computers) {
    
    $Session = New-CimSession $Computer
    
    $DiskSpace = Get-CimInstance -ClassName Win32_LogicalDisk -CimSession $Session

    [pscustomobject]@{
    Computername = $DiskSpace.PSComputerName    
    DriveLetter = $DiskSpace.DeviceID
    Drivetype = $DiskSpace.DriveType
    Size = ($DiskSpace.Size /1GB)
    Freespace = ($DiskSpace.FreeSpace /1GB)
    PercentFree = ('{0:P}' -f ($DiskSpace.FreeSpace/ $DiskSpace.size ))
    }
}
    Remove-CimInstance $Session

 # foreach Diskspace


$Out | Export-csv C:\Temp\diskspace.csv -Force 

$Myarray = @()

Test-Connection -TargetName (Get-ADComputer -Filter 'name -like "int*t"').name -Count 1 | ForEach-Object {

    if ($_.Status -eq 'success') {
        $Myarray += $_.Destination
        Write-Host "Test has succeeded"
    }else {
        Write-Host "Test has failed"
    }
}

$test = 'test'