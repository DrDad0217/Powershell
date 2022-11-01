# Notes

Output from a function should be to the PowerShell pipeline only. Stuff like creating
a file on disk, updating a database, and other actions aren’t output, they’re
actions. Obviously, a function can perform one of those actions if that’s what the
function does.



# Practice question

You need to review departmental shares and identify files that haven’t been
modified in over a year. Your boss wants an Excel spreadsheet that shows the file
path, the size, when it was created, when it was last modified, and the file owner.
Here’s a tip: Don’t worry about automating Excel. All you need is a CSV file that
can be opened and saved in Excel.



```powershell



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
```
# Making Tools

Tools do one thing and one thing only

```powershell
Design examples and how you want to be able to use the tool.

Get-MachineInfo -ComputerName CLIENT #Retrieving info using computername parameter
Get-MachineInfo -ComputerName CLIENTA,CLIENTB #Accepting multiple values
Get-MachineInfo -ComputerName (Get-Content names.txt)
Get-ADComputer -id CLIENTA | Select -Expand name | 

```


Creating a tool to retrieve PC information.

```powershell
Tool that generates the following

*HostName
*Manufacturer
*Model
*OS version and build number
*Service pack version
*Installed RAM
*Processor type
*Processor socket count
*Total core count
*Free space on system drive (usually C: but not always)


#First set
*HostName
*Manufacturer
*Model
#Command to retrieve data
Get-CimInstance -ClassName Win32_ComputerSystem -CimSession 

#Second Set
*OS version  
*Build number
*Service pack version
#Command to retrieve data
Get-CimInstance -ClassName Win32_OperatingSystem

#Third set
*Installed RAM
#Command to retrieve data
Get-ciminstance -ClassName Win32_PhysicalMemory

#Fourth set
*Processor type
*Processor socket count
*Total core count

#Command to retrieve data
Get-ciminstance -ClassName Win32_Processor

#Fifth set
*Free space on system drive (usually C: but not always)

#Command to retrieve data
Get-ciminstance -ClassName Win32_LogicalDisk

```

# Different Streams/Pipelines

## Write-Verbose


```powershell
Function TryMe {
[cmdletbinding()]
Param(
[string]$Computername
)
Begin {
Write-Verbose "[BEGIN ] Starting: $($MyInvocation.Mycommand)"
Write-Verbose "[BEGIN ] Initializing array"
$a = @()
} #begin
Process {
Write-Verbose "[PROCESS] Processing $Computername"
# code goes here
} #process
End {
Write-Verbose "[END ] Ending: $($MyInvocation.Mycommand)"
} #end
} #function

```
 This uses **Write-verbose** with the to display the function name and what block is being executed.

## Write-Information
```powershell

# 1
Function Example {
[CmdletBinding()]
Param()
Write-Information "First message" -tag status
Write-Information "Note that this had no parameters" -tag notice
Write-Information "Second message" -tag status
}


# 2
function Example {
[CmdletBinding()]
Param()
Write-Information "First message" -tag status

Write-Information "Note that this had no parameters" -tag notice
Write-Information "Second message" -tag status
}
Example -InformationAction SilentlyContinue -IV x
$x | where tags -in @('notice')

# 3
function Example {
[CmdletBinding()]
Param()
Write-Information "First message" -tag status
Write-Information "Note that this had no parameters" -tag notice
Write-Information "Second message" -tag status
}
Example -InformationAction SilentlyContinue -IV x
$x | where tags -in @('notice')
```






