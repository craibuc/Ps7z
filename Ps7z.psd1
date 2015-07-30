<#
Module manifest for module 'Ps7z'

Generator: Craig Buchanan <craibuc@gmail.com>
Generated: 2015-06-04
Sources:
    http://mats.gardstad.se/matscodemix/2009/02/05/calling-7-zip-from-powershell/
    http://www.dotnetperls.com/7-zip-examples

#>

@{

    # Script module or binary module file associated with this manifest
    ModuleToProcess = 'Ps7z.psm1'

    # Version number of this module.
    ModuleVersion = '0.0.2'

    # ID used to uniquely identify this module
    GUID = 'B05A1456-0AB2-11E5-911B-2FCC40254040'

    # Author of this module
    Author = 'Craig Buchanan <craibuc@gmail.com>'

    # Company or vendor of this module
    CompanyName = ''

    # Copyright statement for this module
    Copyright = '(c) 2015'

    # Description of the functionality provided by this module
    Description = 'PowerShell interface to 7-Zip'

    # Minimum version of the Windows PowerShell engine required by this module
    # PowerShellVersion = '3.0'

    # Name of the Windows PowerShell host required by this module
    PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    PowerShellHostVersion = ''

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = ''

    # Processor architecture (None, X86, Amd64, IA64) required by this module
    ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules = 'Ps7z.psm1'

    # Functions to export from this module
    FunctionsToExport = '*'

    # Cmdlets to export from this module
    CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport = '*'

    # List of all modules packaged with this module
    ModuleList = @()

    # List of all files packaged with this module
    FileList = @()

    # Private data to pass to the module specified in ModuleToProcess
    PrivateData = ''

}