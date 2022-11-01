function Get-CimInfo {
    param (
        $Computername,
        $DataType
    )

    $cimparams = @{Computername = $Computername }
$props = @('PSComputername')
Switch ($DataType) {
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

$data
    
}


$params = @{

    Identity = $User
    Properties = '*'
    
}

$props = @(
    'GivenName','Surname','SamaccountName'
)

if($user -eq 'schmidtt'){

    $props += 'Company'

}

Get-ADUser @params | Select $props