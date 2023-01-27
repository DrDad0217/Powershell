$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Set-ComputerState" {
    Mock Restart-Computer { return 1 }
    Mock Stop-Computer { return 1 }
    It "accepts and restarts one computer name" {
    Set-ComputerState -computername SERVER1 -Action Restart
    Assert-MockCalled Restart-Computer -Exactly 1
    }
    It "accepts and restarts many names" {
    $names = @('SERVER1','SERVER2','SERVER3')
    Set-ComputerState -computername $names -Action Restart
    Assert-MockCalled Restart-Computer -Exactly 3 -Scope it
    }
    It "accepts and restarts from the pipeline" {
    $names = @('SERVER1','SERVER2','SERVER3')
    $names | Set-ComputerState -Action Restart
    Assert-MockCalled Restart-Computer -Exactly 3 -scope it
    }
    }