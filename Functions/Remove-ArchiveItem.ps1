<#
.SYNOPSIS
    Remove item(s) from archive file.

.PARAMETER
    $Archives

.EXAMPLE
    Remove-Item "C:\path\to\archive\archive.zip" "remove.txt"

#>
Function Remove-ArchiveItem {

    [CmdletBinding()]
    param (
    [Parameter(Mandatory=$True)][alias('a')]
    [string]$Archive,

    [Parameter(Mandatory=$True)][alias('f')]
    [string[]]$Files
  )

    BEGIN {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Begin"

        if (-not $7z) {Throw "7z.exe not installed"}
    }
    PROCESS {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Process"

        Foreach ($File In $Files) {

            Write-Verbose "$7z d $($args -join ' ') $Archive $File"
            # invoke command
            & $7z d $Archive $File

        }

    }
    END { Write-Verbose "$($MyInvocation.MyCommand.Name)::End" }

}

Set-Alias 7zri Remove-ArchiveItem
