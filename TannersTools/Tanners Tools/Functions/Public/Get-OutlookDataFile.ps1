# Function
function Get-OutlookDataFile {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true )
        ]
        [String[]]
        $ComputerName,
        [Int]
        $Days 
    )
    
    begin {
     
    
        
    }
    
    process {
        
        if ($Computername) {
        
    
            $Output = Invoke-Command -ComputerName $ComputerName -ScriptBlock {

                $Users = (Get-ChildItem -path C:\users).name
        
                foreach ($User in $Users) {
            
                    Get-ChildItem C:\users\$user\appdata -Include *.nst, *.ost -Recurse -ea Ignore #| Where LastWriteTime -Lt (Get-Date).AddDays(-$Using:Days) 
                   
        
                }
        
            } #Invoke Command
        
            $myobject = foreach ($Item in $Output) {
        
        
                [PSCustomObject]@{
                    FileName       = $Item.name
                    'FileSize(MB)' = ($Item.Length / 1mb)  
                    ModifiedDate   = $Item.LastWriteTime
                    ComputerName   = $Item.PSComputerName.ToUpper()
                    Directory      = $Item.Directory
                    Fullname       = $Item.FullName
                }
            } # foreach statement

        
       
  
        } # if statement
        else {
        
            Get-ChildItem C:\users\$user\appdata -Include *.nst, *.ost -Recurse -ea Ignore |  Where LastWriteTime -Lt (Get-Date).AddDays($Days) 

        }
    }
    
    end {
        
        $defaultProperties = @('FileName', 'FileSize(MB)', 'ModifiedDate', 'ComputerName')
        $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet(‘DefaultDisplayPropertySet’, [string[]]$defaultProperties)
        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
        $myobject | Add-Member MemberSet PSStandardMembers $PSStandardMembers

        $myobject
    }
}



<#

foreach($item in $TestOst){

    Remove-item $item -WhatIf
}

Invoke-Command -ComputerName int012055t -ScriptBlock {Test-Path 'C:\users\schmidtt\AppData\Local\Microsoft\Outlook\Tanner.Schmidt@cityofvancouver.us - Internal.ost'}

#>