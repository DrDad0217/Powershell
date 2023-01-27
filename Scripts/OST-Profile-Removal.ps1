$Users = (Get-ChildItem -path C:\users).name
        
foreach ($User in $Users) {
            
    $files = Get-ChildItem C:\users\$user\appdata -Include *.nst, *.ost -Recurse -ea Ignore |  Where LastWriteTime -Lt (Get-Date).AddDays(-60)

    if ($null -ne $files) {

                                             
        Remove-item -Path $files 
    }

                    

}

$Log = New-Item 'C:\Temp\OSTfile2.txt' -Force
$Users = (Get-ChildItem -path C:\users).name
        
foreach ($User in $Users) {
            
    $files = Get-ChildItem C:\users\$user\appdata -Include *.nst, *.ost -Recurse -ea Ignore 

    if ($null -ne $files) {

                                             
        Add-Content -Path C:\Temp\ostfile2.txt -Value $files.FullName
    }

    
}