#Excel sheet that shows Path,LastWriteTime,CreationDate,SizeMB,Owner
$Path = $env:USERPROFILE
$Csv = New-Item $env:USERPROFILE\Test.csv -Force

$FolderProps = Get-ChildItem $Path | ForEach-Object{

$Acl = Get-Acl -path $Path 

[PSCustomObject]@{
   
    Path = $_.FullName
    Modified = $_.LastWriteTime 
    CreatedOn = $_.CreationTime 
    Name = $_.Length / 1MB
    Owner = $Acl.Owner
    
}
} 

$myobj = [PSCustomObject]@{
   
   FirstName = 'Tanner'
   Lastname = 'Schmidt'
   IsMale = $true
   Age = '29'
   
}

$Myhash = [ordered]@{
   
    FirstName = 'Tanner'
    Lastname = 'Schmidt'
    IsMale = $true
    Age = '29'
    
 }




function get-stuff {
    [CmdletBinding()]
    param (
        [string[]]
        $Computername
        
    )
    
    begin {


        
        
    }
    
    process {

        foreach ($Computer in $Computername) {
            $Computer
        }
        
    }
    
    end {
        
    }
}

$First = 'Tanner'
$Last = 'Schmidt'

$myobj = [PSCustomObject]@{
    Name = $First
}

function Example {
    [CmdletBinding()]
    Param()
    Write-Information "First message" -tag status
    Write-Information "Note that this had no parameters" -tag notice
Write-Information "Second message" -tag status
}
Example -InformationAction SilentlyContinue -IV x
$x | where tags -in @('notice')