Write-Host "Importing module Ps7z..."

$7z=@("$env:ProgramFiles\7-Zip\7z.exe","$env:ProgramFiles(x86)\7-Zip\7z.exe","$env:ProgramW6432\7-Zip\7z.exe") | Foreach {
    if (Test-Path $_) { $_ }
}

#
# http://mats.gardstad.se/matscodemix/2009/02/05/calling-7-zip-from-powershell/
# http://www.dotnetperls.com/7-zip-examples
#

<#
.SYNOPSIS
Create an archive file (in 7z or Zip format), optionally adding a password.

.DESCRIPTION

.PARAMETER $Paths
File(s) to be compressed.

.PARAMETER $Type
File compression algorythm; defaults to zip

.PARAMETER $Archive
[path\to\[archive.xxx]]; if omitted, path and name generated from source

.PARAMETER $Password
Optional passowrd, in plain text

.EXAMPLE
    PS> New-Archive "C:\Users\XYZ\Desktop\Foobar.pdf" -Type zip

.EXAMPLE
    PS> New-Archive "C:\Users\XYZ\DesktopFoobar.pdf" -Type zip "C:\Users\XYZ\Desktop\Foobar.zip" "PAssW0rD"

.EXAMPLE
    PS> Get-Item -Path ".\a folder" | New-Archive -Type zip

.LINK
#>
Function New-Archive {

    [CmdletBinding()]
    param (
		[Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)][Alias('FullName')]
		[string[]]$Paths,

		[Parameter(Mandatory=$False)][ValidateSet('7Z','ZIP')][Alias('t')]
        [ValidateNotNullorEmpty()]
		[string]$Type='ZIP',

		[Parameter(Mandatory=$False)][Alias('a')]
		[string]$Archive,

		[Parameter(Mandatory=$False)][Alias('p')]
		[string]$Password
	)

    BEGIN {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Begin"

        if (-not $7z) {Throw "7z.exe not installed"}

        $files=0

    } # BEGIN

    PROCESS {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::Process"

        #Take all the paths passed from the pipeline.
        Foreach ($Path in $Paths) {

            $files+=1

            #
            # use the first file/folder to determine the location of the archive if the $Destination isn't supplied
            #
            if ($files -eq 1) {

                if ( -not $Archive ) {
#                if ( $Destination ) { $Archive = $Destination }
#                else {

                    # FileInfo object
                    $Item = Get-Item $Path
                    switch ($Item) {
                        {$_ -is [System.IO.DirectoryInfo]} { $Archive = $Item.Parent.FullName + '\' + 'Archive.' + $Type.ToLower() }
                        {$_ -is [System.IO.FileInfo]} { $Archive = $Item.Directory.FullName + '\' + 'Archive.' + $Type.ToLower() }
                    }

                }
            }

            # build argument list
            $args = @()
            $args += "-t$Type"
            if ($Password){$args += "-p$Password"} # add password, if supplied

            Write-Verbose "$7z a $($args -join ' ') $Archive $Path"
            # invoke command
            & $7z 'a' @args $Archive $Path # > $null

        } # Foreach

    } # PROCESS

    END {
        Write-Verbose "$($MyInvocation.MyCommand.Name)::End"

        if ($files -eq 1) {
            Write-Verbose 'One file--name archive to match file/directory'
        }
        else {
            Write-Verbose 'Many files--name archive to match parent directory'
        }

    } # END

}

Export-ModuleMember New-Archive
Set-Alias 7zna New-Archive
Export-ModuleMember -Alias 7zna

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

Export-ModuleMember Expand-Archive
Set-Alias 7zea Expand-Archive
Export-ModuleMember -Alias 7zea
 
<#
.SYNOPSIS
    Show contents of archive file(s).

.PARAMETER
    $Archives

.EXAMPLE
    show-Archive "C:\path\to\archive\archive.zip"

#>
Function Show-Archive () {

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
            # invoke command
            & $7z l @args $Archive

        }

    }
    END { Write-Verbose "$($MyInvocation.MyCommand.Name)::End" }

}

Export-ModuleMember Show-Archive
Set-Alias 7zsa Show-Archive
Export-ModuleMember -Alias 7zsa

<#
.SYNOPSIS
    Remove item(s) from archive file.

.PARAMETER
    $Archives

.EXAMPLE
    Remove-Item "C:\path\to\archive\archive.zip" "remove.txt"

#>
<#
Function Remove-Item {

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

            # FileInfo object
            $Item = Get-ChildItem $File

            # build argument list
            $args = @()

            Write-Verbose "$7z d $($args -join ' ') $Archive $File"
            # invoke command
            & $7z d @args $Archive $File

        }

    }
    END { Write-Verbose "$($MyInvocation.MyCommand.Name)::End" }

}

Export-ModuleMember Remove-Item
Set-Alias 7zri Remove-Item
Export-ModuleMember -Alias 7zri
#>