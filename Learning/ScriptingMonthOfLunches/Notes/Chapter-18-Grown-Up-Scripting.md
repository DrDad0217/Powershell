# Notes

- Use Source Control
- Use full cmdlet and parameter names
- Add inline comments to your code
- Format your code
- Write comments on the end point of constructors(Foreach,trycatch,until)
- Use Write-Progress in place of Write-Host
- Use single quotes unless you are including a variable
- Be elegant, try to not reuse code when possible

### Elegance example

```powershell
Switch ($value) {
    "OS" {
        $data = Get-Ciminstance -class win32_operatingsystem -computername
        $computername | Select PSComputername, Version, Caption
    }
    "CS" {
        $data = Get-Ciminstance -class win32_computersystem -computername
        $computername | Select PSComputername, Model, Manufacturer
    }
    "CPU" {
        $data = Get-Ciminstance -class win32_processor -computername
        $computername | Select PSComputername, CPUID, Name, MaxClockSpeed
    }
    "Memory" {
        $data = Get-Ciminstance -class win32_physicalmemory -computername
        $computername | Select PSComputername, Banklabel, Capacity, Speed
    }
}

# Same example with elegance

$cimparams = @{Computername = $Computername }
$props = @('PSComputername')
Switch ($value) {
    'OS' {
        $cimparams.Add('classname', 'win32_operatingsystem')
        $props += 'Version', 'Caption'
    }
    'CS' {
        $cimparams.Add('classname', 'win32_computersystem')
        $props += 'Model', 'Manufacturer'
    }
    'CPU' {
        $cimparams.Add('classname', 'win32_processor')
        $props += 'CPUID', 'Name', 'MaxClockSpeed'
    }
    'Memory' {
        $cimparams.Add('classname', 'win32_physicalmemory')
        $props += 'Banklabel', 'Capacity', 'Speed'
    }
}

$data = Get-CimInstance @cimparams | Select-object -Property $props
```
