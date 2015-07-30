$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Show-ArchiveItems" {
    It -skip "does something useful" {
        $true | Should Be $false
    }
}
