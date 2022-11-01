#Requires -Version 3.0 -RunasAdministrator


function Get-MachineInfo {

    <# PSFunctionInfo

Version 1.0.0
Author Tanner Schmidt

Copyright 2022
Description Retrieves machine info
Guid 065c8d3a-a24a-424c-a091-e2dad6146986
Tags 
LastUpdate 9/21/2022 4:38 PM
Source C:\users\covschmidtt\GitHub\Powershell\Learning\Get-MachineInfo.ps1

#>
<#
.SYNOPSIS
    Retrieves machine information
.PARAMETER Computername
Supply the name of the machine you would like to run the command against
.PARAMETER LogFilePath
Supply path for log file destination
.LINK
Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Get-MachineInfo -ComputerName 'INT012055T'
    Get-MachineInfo -ComputerName 'INT012055T' -LogFilePath 'C:\Temp'
#>


    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $True,
            Mandatory = $True)]
        [Alias('CN', 'MachineName', 'Name')]
        [string[]]$ComputerName,
        
        [string]$LogFailuresToPath,

        [ValidateSet('Wsman', 'Dcom')]
        [string]$Protocol = "Wsman",

        [switch]$ProtocolFallback
    )
 
    
    BEGIN {
        
        
        Write-Information "Execution Metadata:" -Tags meta
        Write-Information "User = $($env:userdomain)\$($env:USERNAME)"
        $id = [System.Security.Principal.WindowsIdentity]::GetCurrent() 
        $IsAdmin = [System.Security.Principal.WindowsPrincipal]::new($id).IsInRole('administrators') 
        Write-Information "Computername = $env:COMPUTERNAME" -Tags meta
        Write-Information "Is Local Admin = $IsAdmin" -Tags meta
        Write-Information "OS = $((Get-CimInstance Win32_Operatingsystem).Caption)" -Tags meta
        Write-Information "Host = $($host.Name)" -Tags meta
        Write-Information "PSVersion = $($PSVersionTable.PSVersion)" -Tags meta
        Write-Information "Runtime = $(Get-Date)" -Tags meta

      
    }

    PROCESS {
        foreach ($Computer in $Computername) {
 
            # Establish session protocol
            if ($Protocol -eq 'Dcom') {
                $Option = New-CimSessionOption -Protocol Dcom
            }
            else {
                $Option = New-CimSessionOption -Protocol Wsman
            }

            Try {

                $OfficeArch = Invoke-Command -ComputerName $ComputerName -ScriptBlock { Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" | Select -ExpandProperty Platform }
                
                $MonthlyOSRelease = Invoke-Command -ScriptBlock { (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ubr).ubr }
                
                Write-Information -Message "Creating session on $Computer"-Tags Process
                $Session = New-CimSession -ComputerName $computer -SessionOption $Option
 
                Write-Information -Message "Querying Data from $Computer"
                $OS_Params = @{'ClassName' = 'Win32_OperatingSystem'
                    'CimSession'           = $Session
                }
                $OS = Get-CimInstance @OS_Params
                
                $Bios_Params = @{'Classname' = 'Win32_bios'
                    'CimSession'             = $Session
                }
                $Bios = Get-CimInstance @Bios_Params
                
                $CS_Params = @{'ClassName' = 'Win32_ComputerSystem'
                    'CimSession'           = $Session
                }
                $CS = Get-CimInstance @CS_Params

                $Sysdrive = $os.SystemDrive
                $Drive_params = @{'ClassName' = 'Win32_LogicalDisk'
                    'Filter'                  = "DeviceId='$Sysdrive'"
                    'CimSession'              = $Session
                }
                $Drive = Get-CimInstance @Drive_params

                $Proc_Params = @{'ClassName' = 'Win32_Processor'
                    'CimSession'             = $Session
                }
                $proc = Get-CimInstance @Proc_Params |
                Select-Object -first 1

  
                Write-Information -MessageData "Removing Session from $Computer"
                $Session | Remove-CimSession
  
                Write-Information -MessageData "Creating output for $Computer"
                [PSCustomObject]@{
                
                    'Manufacturer'       = $CS.manufacturer
                    'Model'              = $CS.model
                    'BiosVersion'        = $Bios.SMBIOSBIOSVersion
                    'ComputerName'       = $Computer
                    'Serial'             = $Bios.Serialnumber
                    'OSBuild'            = $OS.buildnumber
                    'MonthlyBuild'       = $MonthlyOSRelease
                    'OSArchitecture'     = $Proc.addresswidth
                    'CPUCores'           = $CS.numberoflogicalprocessors
                    'RAM'                = $CS.totalphysicalmemory 
                    'DriveFreeSpaceGB'   = $Drive.freespace 
                    'PercentFreeSpace'   = $('{0:P}' -f ($drive.FreeSpace/ $drive.size ))
                    'OfficeArchitecture' = $OfficeArch
                }
                
            }
            Catch {

                Write-Warning "FAILED $computer on $protocol"
              
                If ($ProtocolFallback) {
                    If ($Protocol -eq 'Dcom') {
                        $newprotocol = 'Wsman'
                    }
                    else {
                        $newprotocol = 'Dcom'
                    } #if protocol
                    Write-Verbose "Trying again with $newprotocol"
                    $params = @{'ComputerName' = $Computer
                        'Protocol'             = $newprotocol
                        'ProtocolFallback'     = $False 
                    }
                    If ($PSBoundParameters.ContainsKey('LogFailuresToPath')) {
                        $Params += @{'LogFailuresToPath' = $LogFailuresToPath }
                    } #if logging
                    Get-MachineInfo @Params
                } 
                If (-not $ProtocolFallback -and
                    $PSBoundParameters.ContainsKey('LogFailuresToPath')) {
                    Write-Verbose "Logging to $LogFailuresToPath"
                    $Computer | Out-File $LogFailuresToPath -Append
                } # if write to log
            } #try/catch
        
        
        
        } #foreach
    } #PROCESS

    END {}

} #function
