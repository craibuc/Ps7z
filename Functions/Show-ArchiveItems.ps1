<#
.SYNOPSIS
    Show contents of archive file(s).

.PARAMETER
    $Archives

.EXAMPLE
    Show-ArchiveItems "C:\path\to\archive\archive.zip"

#>
Function Show-ArchiveItems () {

    [CmdletBinding()]
    param (
    [Parameter(Mandatory=$True)][alias('a')]
    [string[]]$Archives
  )

    BEGIN {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Begin"

        if (-not $7z) {Throw "7z.exe not installed"}
    }
    PROCESS {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Process"

        Foreach ($Archive In $Archives) {

            # FileInfo object
            $Item = Get-ChildItem $Archive

            # build argument list
            $args = @()
            $args += "-t$($Item.Extension.Replace('.',''))" # archive type (e.g. 7z,zip) extracted from file's extension

            Write-Verbose "$7z l $($args -join ' ') $Archive"
            # invoke command; capture STDOUT
            #& $7z l @args $Archive
            $output = & $7z l @args $Archive

            #
            # parse stdout; convert to PsObject[] 
            # http://social.technet.microsoft.com/wiki/contents/articles/4244.how-to-convert-text-output-of-a-legacy-console-application-to-powershell-objects.aspx
            #
            $output = $output[12..($output.Length-3)] # remove stuff before and after dash separators (including dash rows)
            $output | foreach {
                $parts = $_ -split "\s+", 6
                New-Object -Type PSObject -Property @{
                    #Date = $parts[0]
                    #Time = $parts[1]
                    DateTime = "{0} {1}" -f $parts[0], $parts[1]
                    Attributes = $parts[2]
                    Size = $parts[3]
                    Compressed = $parts[4]
                    Name = $parts[5]
                }
            }

        }

    }
    END { Write-Verbose "$($MyInvocation.MyCommand.Name)::End" }

}

Set-Alias 7zsa Show-ArchiveItems
