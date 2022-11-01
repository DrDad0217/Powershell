function Get-FolderSize {
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True)]
    [string[]]$Path
    )
    BEGIN {}
    PROCESS {
    ForEach ($folder in $path) {
    Write-Verbose "Checking $folder"
    if (Test-Path -Path $folder) {
    Write-Verbose " + Path exists"
    $params = @{'Path'=$folder
    'Recurse'=$true
    'File'=$true}
    $measure = Get-ChildItem @params |
    Measure-Object -Property Length -Sum
    [pscustomobject]@{'Path'=$folder
    'Files'=$measure.count
    'Bytes'=$measure.sum /1GB}
    } else {
    Write-Verbose " - Path does not exist"
    [pscustomobject]@{'Path'=$folder
    'Files'=0
    'Bytes'=0}
    } #if folder exists
    } #foreach
    } #PROCESS
    END {}
    } #function