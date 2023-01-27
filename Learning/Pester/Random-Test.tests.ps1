BeforeAll{

    $Tanner = @{

        Eyes = 'Blue'
        Height = '5,7'
        Weight = '180lbs'
        Gender = 'Male'
    }
}

Describe 'Tanner'{

    It 'Tanner should have blue eyes'{

        $Tanner.Eyes | Should -be 'blue'
    }
}