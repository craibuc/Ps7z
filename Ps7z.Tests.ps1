Import-Module Ps7z -Force

Describe "7z" {

    Write-Host "TestDrive: $TestDrive"

    Context "Basic operation" {

        $content="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor."
        $file = New-item "TestDrive:\one.txt" -Type File

        Set-Content $file -value $content

#        $files = @('TestDrive:\one.txt','TestDrive:\two.txt')
#        Foreach ($file In $files) {
#            Set-Content $file -value $content
#        }
        
        $Output = New-Item "TestDrive:\Destination" -Type Directory

        # force TestDrive to be converted to an actual path
        $archive = "$TestDrive\Archive.zip"

        It "Should create a compressed file" {

            { New-Archive $file -Type ZIP } | Should Not Throw

            # archive should exist
            Test-Path $archive | Should Be $true

        }

        It "Should expand a compressed file" {

            $Expected = (Join-Path $Output (Get-Item $file).name)

            # act/assert
            { Expand-Archive $archive -Output $Output } | Should Not Throw
            
            # file should exist
            Test-Path $Expected | Should Be $true

            # the content should match
            Get-Content $Expected | Should BeExactly $content

        }

        It "Should list the archive's contents" {
            { Show-ArchiveItems $archive } | Should Not Throw
        }

        It "Should remove an item from an archive" {
            #{ Remove-ArchiveItem $archive 'two.txt' } | Should Not Throw
        }

    }

}

Describe "Aliases" {

    It "New-Archive alias should exist" {
        (Get-Alias -Definition New-Archive).name | Should Be "7zna"
    }
    It "Expand-Archive alias should exist" {
        (Get-Alias -Definition Expand-Archive).name | Should Be "7zea"        
    }
    It "Show-ArchiveItems alias should exist" {
        (Get-Alias -Definition Show-ArchiveItems).name | Should Be "7zsa"        
    }
    It "Remove-ArchiveItem alias should exist" {
        (Get-Alias -Definition Remove-ArchiveItem).name | Should Be "7zri"        
    }

}