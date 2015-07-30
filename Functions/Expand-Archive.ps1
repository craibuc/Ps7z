<#
.SYNOPSIS
    Expand an archive file.

.DESCRIPTION
.PARAMETER $Archive
.PARAMETER $Directory
.PARAMETER $Password

.EXAMPLE
   PS> Expand-Archive "C:\Users\XYZ\Desktop\Archive.7z"

.EXAMPLE
   PS> Expand-Archive "C:\Users\XYZ\Desktop\Archive.7z" "C:\Users\XYZ\Desktop\"

.EXAMPLE
    PS> Expand-Archive "C:\Users\XYZ\Desktop\Archive.7z" "C:\Users\XYZ\Desktop\" "PAssW0rD"

#>
Function Expand-Archive () {

    [CmdletBinding()]
    param (
    [Parameter(Mandatory=$True)][alias('a')]
    [string[]]$Archives,

    [Parameter(Mandatory=$false)][alias('o')]
    [string]$Output,

    [Parameter(Mandatory=$False)][Alias('p')]
    [string]$Password
  )

    BEGIN {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Begin"

        if (-not $7z) {Throw "7z.exe not installed"}

        Write-Verbose "Output: $Output"

    }

    PROCESS {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Process"

        Foreach ($Archive In $Archives) {

            Write-Verbose "Archive: $($Archive)"

            # FileInfo object
            $Item = Get-ChildItem $Archive

            # build argument list
            $args = @()
#            $Type = $Item.Extension.Replace('.','')
            $args += "-t$($Item.Extension.Replace('.','').ToUpper())" # archive type (e.g. 7z,zip) extracted from file's extension
            $args += '-y' # indicate yes to all questions (e.g. force overwrite)
            if ($Output){$args += "-o$Output"} # add output directory, if supplied
            if ($Password){$args += "-p$Password"} # add password, if supplied

            Write-Verbose "$7z e $($args -join ' ') $Archive"
            # invoke command
            & $7z e @args $Archive # > $null
        }

    }

    END { Write-Verbose "$($MyInvocation.MyCommand.Name)::End" }

}

Set-Alias 7zea Expand-Archive
