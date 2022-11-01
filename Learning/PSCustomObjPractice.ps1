$MyObjectMD = [pscustomobject]@{

    TimeStamp = (Get-Date -Format MM-dd-yy:mm:ss)
    ScriptRanBy = $env:USERNAME
    Computer = $env:COMPUTERNAME
    OS =  (Get-CimInstance -ClassName Win32_OperatingSystem | select -ExpandProperty Caption )
    OSBuildNumber = (Get-CimInstance -ClassName Win32_OperatingSystem | select -ExpandProperty BuildNumber )
    

} 

$MyObjectMD.PSObject.Properties.Add(
            # A script property can consist of a name, a getter, and (optionally) a setter.
            [psscriptproperty]::new('CustomProperty',
                {
                    # getter
                    $this.ScriptRanBy + "Is cool"
                },
                {
                    # setter
                    param($val)
                    $this.BaseProperty = - [int]($val)
                }
            )
        )