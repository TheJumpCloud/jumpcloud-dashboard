Describe "Testing JumpCloud Systems Dashboard" {
    BeforeAll {

        # Run setupDashboardt.ps1
        # REQUIRED: Firefox must be installed

        $Driver = Start-SeFirefox -Headless
        Enter-SeUrl "http://127.0.0.1:8003/Systems" -Driver $Driver
    }
    Context "Verifying System Dashboard Components" {

        It "Verifies the OS component" {
            $Element = Find-SeElement -Driver $Driver -TagName "OS"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the SystemsMFA component" {
            $Element = Find-SeElement -Driver $Driver -TagName "SystemsMFA"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the NewSystems component" {
            $Element = Find-SeElement -Driver $Driver -TagName "NewSystems"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the AgentVersion component" {
            $Element = Find-SeElement -Driver $Driver -TagName "AgentVersion"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the OSVersion component" {
            $Element = Find-SeElement -Driver $Driver -TagName "OSVersion"
            $Element.Displayed | Should Be $true
        }
        It "Verifies the LastContact component" {
            $Element = Find-SeElement -Driver $Driver -TagName "LastContact"
            $Element.Displayed | Should -Be $true
        }

    }
    Context "Testing Click Actions on Systems Dashboard"{
        # could break if the cards are rearranged
        It "Sort By Created - New Systems (Created in last 7 days)"{
            # Select the "created" text of the New Systems card
            $Element = Find-SeElement -Driver $Driver -XPath "/html/body/div[1]/div/main/div/div/div[7]/newsystems/div/div/div[1]/table/thead/tr/th[3]/span"
            # click and sort by created
            if ($Element) {
                $Element.click()
            }
            # get systems
            $sys = Get-JCSystem -filterDateProperty created -dateFilter after  -date (Get-Date).AddDays(-7)
            # If systems is greater or equal to 2
            if ($sys.Length -ge 2 ) {
                # Select first date in the New System's card
                $First = Find-SeElement -Driver $Driver -XPath "/html/body/div[1]/div/main/div/div/div[7]/newsystems/div/div/div[1]/table/tbody/tr[1]/td[3]/span"
                $time1 = $First.text
                # strip comma, time should be system readable
                $time1 = $time1 -replace ',', ""
                # $convert1 = [datetime]::ParseExact($time1, "MMM dd yyyy h:mm tt", $null)
                # Select second data in the next System's card
                $Next = Find-SeElement -Driver $Driver -XPath "/html/body/div[1]/div/main/div/div/div[7]/newsystems/div/div/div[1]/table/tbody/tr[2]/td[3]/span"
                $time2 = $Next.text
                # strip comma, time should be system readable
                $time2 = $time2 -replace ',', ""
                # $convert2 = [datetime]::ParseExact($time2, "MMM dd yyyy h:mm tt", $null)
                # compare time, positve diff means that the dates are sorted correctly
                $diff = (New-TimeSpan -Start $time1 -End $time2).ToString()
                # diff should be greater or equal to 0 if time is sorted correctly
                $diff | Should BeGreaterOrEqual 0
            }
        }
    }
    Context "Testing the cases where no systems are to be displayed" {
        It "No MFA Systems"{
            $MFASystems = Get-SystemsWithLastContactWithinXDays -days 7
            If ($MFASystems.Length -eq 0) {
                $Element = Find-SeElement -Driver $Driver -TagName "SystemsMFA"
                $Element.Text | Should BeLike "*None of your systems have MFA enabled."
            }
        }
        It "No New Systems" {
            $MFASystems = Get-SystemsWithLastContactWithinXDays -days 7
            If ($MFASystems.Length -eq 0) {
                $Element = Find-SeElement -Driver $Driver -TagName "NewSystems"
                $Element.Text | Should BeLike "*No new systems have been added to your JumpCloud Organization*"
            }
        }
    }
    AfterAll {
        Stop-SeDriver $Driver
    }

}