Write-Host "Importing module Ps7z..."

#
# Locate 7z.exe and create an alias
#
$a = @("$env:ProgramFiles\7-Zip\7z.exe","$env:ProgramFiles(x86)\7-Zip\7z.exe","$env:ProgramW6432\7-Zip\7z.exe") 
$7z= ($a | Foreach {
        if (Test-Path $_) {
            $_
        }
    })[0] # Foreach

Write-Host "7z: $7z"

#
# load (dot-source) *.PS1 files, excluding unit-test scripts (*.Tests.*), and disabled scripts (__*)
#
Get-ChildItem "$PSScriptRoot\Functions\*.ps1" | 
    Where-Object { $_.Name -like '*.ps1' -and $_.Name -notlike '__*' -and $_.Name -notlike '*.Tests*' } | 
    % { . $_ }

Export-ModuleMember New-Archive
Export-ModuleMember -Alias 7zna

Export-ModuleMember Expand-Archive
Export-ModuleMember -Alias 7zea

Export-ModuleMember Show-ArchiveItems
Export-ModuleMember -Alias 7zsa

Export-ModuleMember Remove-ArchiveItem
Export-ModuleMember -Alias 7zri
