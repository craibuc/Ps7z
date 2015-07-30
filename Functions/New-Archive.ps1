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
            # & $7z 'a' @args $Archive $Path # > $null
            $output = & $7z 'a' @args $Archive $Path

            #
            # parse stdout; convert to PsObject[] 
            # http://social.technet.microsoft.com/wiki/contents/articles/4244.how-to-convert-text-output-of-a-legacy-console-application-to-powershell-objects.aspx
            #
            $output = $output[7..($output.length-4)] # remove stuff before and after dash separators (including dash rows)
            $output | foreach {
                $parts = $_ -split "\s+", 2
                New-Object -Type PSObject -Property @{
                    Name = $parts[1]
                }
            }

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

Set-Alias 7zna New-Archive
