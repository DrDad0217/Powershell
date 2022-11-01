function PingTest {
    [CmdletBinding()]
    param (
        
        [Parameter(ValueFromPipeline = $true)]
        [string[]]    
        $Computername,
        [string]
        $Path
    )
    
  
    
    process {
        
        foreach ($comp in $Computername) {
    
            $pingtest = Test-Connection -ComputerName $comp -Quiet -Count 1 -ErrorAction SilentlyContinue

            if ($pingtest) {

                [PSCustomObject]@{
                    Computername = $comp
                    Status       = 'Online'
                }

                
            }
            else {
                Add-Content -Path (New-Item -path C:\Temp\pingtest-$(Get-date -Format MM-dd-yy).txt -Force) -value $comp
            }

           
     
        } # foreach
    }
    
   
}