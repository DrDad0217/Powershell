function Get-InstalledSoftware {
    [CmdletBinding()]
    	
    param(
        
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [String[]]
        $ComputerName
        
        )

    PROCESS {
  
        $Online = @()  

        foreach ($Computer in $Computername) {
   
            if ((Test-Connection -TargetName $Computer -Quiet -Count 1 -ErrorAction SilentlyContinue )) { $Online += $Computer }

            else {

                Write-Warning -Message "$Computer is offline"
            }

        } #foreach computer

        try {

            $Applications = foreach ($Machine in $Online) {
                Invoke-Command -ComputerName $Machine -ErrorAction SilentlyContinue -ScriptBlock {
          
                    Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where DisplayName -ne $Null # 32 Bit
                    Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where DisplayName -ne $Null             # 64 Bit
          
                } #Invoke Command
            
            } #Applications variable foreach
            
        }
        catch {

            Write-Warning "Could not resolve hostname for $Computer"
        } #try catch


        $Myobject = foreach ($Software in $Applications) {
            [PSCustomObject]@{
        
                ComputerName    = $Software.PSComputerName.toupper()
                DisplayName     = $Software.Displayname
                DisplayVersion  = $Software.DisplayVersion
                InstallSource   = $Software.InstallSource
                EstimatedSize   = $Software.EstimatedSize
                UninstallString = $Software.UninstallString

        }

            } # foreach custom object
        
        
        # Set default properties to be displayed
        $DefaultProperties = @('Displayname', 'DisplayVersion', 'Computername')
        $DefaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’, [string[]]$defaultProperties)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
        $Myobject | Add-Member MemberSet PSStandardMembers $PSStandardMembers -PassThru
    
    } # Process 
    
} # Function

    
