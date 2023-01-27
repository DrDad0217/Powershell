function Get-Applications {
    [cmdletbinding()]
    param(
        [switch]$Global,
        [switch]$CurrentUser,
        [switch]$AllUsers,
        [switch]$RunningAsAdmin
    )
    # Empty array to store applications
    $Apps = @()
    $32BitPath = "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $64BitPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    if ($Global -or $AllUsers) {
        $Apps += Get-ItemProperty "HKLM:\$32BitPath"
        $Apps += Get-ItemProperty "HKLM:\$64BitPath"
    }
    if ($CurrentUser -or $AllUsers) {
        $Apps += Get-ItemProperty "Registry::\HKEY_CURRENT_USER\$32BitPath"
        $Apps += Get-ItemProperty "Registry::\HKEY_CURRENT_USER\$64BitPath"
    }
    if ($AllUsers -and $RunningAsAdmin) {
        $AllProfiles = Get-CimInstance Win32_UserProfile | Select LocalPath, SID, Loaded, Special | Where {$_.SID -like "S-1-5-21-*"}
        $MountedProfiles = $AllProfiles | Where {$_.Loaded -eq $true}
        $UnmountedProfiles = $AllProfiles | Where {$_.Loaded -eq $false}
        $MountedProfiles | % {
            $Apps += Get-ItemProperty -Path "Registry::\HKEY_USERS\$($_.SID)\$32BitPath"
            $Apps += Get-ItemProperty -Path "Registry::\HKEY_USERS\$($_.SID)\$64BitPath"
        }
        $UnmountedProfiles | % {
            $Hive = "$($_.LocalPath)\NTUSER.DAT"
            if (Test-Path $Hive) {
                REG LOAD HKU\temp $Hive
                $Apps += Get-ItemProperty -Path "Registry::\HKEY_USERS\temp\$32BitPath"
                $Apps += Get-ItemProperty -Path "Registry::\HKEY_USERS\temp\$64BitPath"
                # Run manual GC to allow hive to be unmounted
                [GC]::Collect()
                [GC]::WaitForPendingFinalizers()
                REG UNLOAD HKU\temp
            }
        }
    }

foreach($App in $Apps){

    [PSCustomObject]@{
        
        DisplayName     = $App.Displayname
        DisplayVersion  = $App.DisplayVersion
        InstallSource   = $App.InstallSource
        EstimatedSize   = $App.EstimatedSize
        UninstallString = $App.UninstallString
    }
    
}
   <#
   $AppOutput = foreach ($App in $Appz) {
       
       [PSCustomObject]@{
           
           ComputerName    = $App.PSComputerName.toupper()
           DisplayName     = $App.Displayname
           DisplayVersion  = $App.DisplayVersion
           InstallSource   = $App.InstallSource
        EstimatedSize   = $App.EstimatedSize
        UninstallString = $App.UninstallString
        
        
    }
} 

#> 

}