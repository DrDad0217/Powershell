function Get-InstalledSoftware {
	
    [CmdletBinding(SupportsShouldProcess)]	
    param(
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [String[]]
        $ComputerName
        

    )

    PROCESS {

        foreach ($Computer in $Computername ) {
        
                $Applications = Invoke-Command -ComputerName $ComputerName {
        
                $Apps = @()
                $Apps += Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where DisplayName -ne $Null # 32 Bit
                $Apps += Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where DisplayName -ne $Null             # 64 Bit
                $Apps
                
       
                
            } 
        
   

        
        }

        $Myobject = foreach ($Software in $Applications) {
            [PSCustomObject]@{
        
                ComputerName    = $Software.PSComputerName
                DisplayName     = $Software.Displayname
                DisplayVersion  = $Software.DisplayVersion
                InstallSource   = $Software.InstallSource
                EstimatedSize   = $Software.EstimatedSize
                UninstallString = $Software.UninstallString

        
            }

            
        
        } # foreach
        
        
        # Set default properties to be displayed
        $DefaultProperties = @('Displayname', 'DisplayVersion', 'Computername')
        $DefaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’, [string[]]$defaultProperties)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
        $Myobject | Add-Member MemberSet PSStandardMembers $PSStandardMembers

        $MyObject

        
       


    } # Process

    
}