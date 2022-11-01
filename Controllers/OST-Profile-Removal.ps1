$Users = (Get-ChildItem -path C:\users).name
        
foreach ($User in $Users) {
            
    $files = Get-ChildItem C:\users\$user\appdata -Include *.nst, *.ost -Recurse -ea Ignore |  Where LastWriteTime -Lt (Get-Date).AddDays(-60)

    if ($null -ne $files) {

                                             
        Remove-item -Path $files 
    }

                    

}

            