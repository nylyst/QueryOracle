#load dependent assemblies
#TODO: Make this more general, should find %ORACLE_HOME% or beginning of %PATH% and walk the paths looking for both DataAccess and ManagedDataAccess, perhaps
#       prompting the user which environment they want to use. (Remembering that DataAccess has some issues, even in the latest version)
[string]$library = [string]::Empty
if([System.Environment]::Is64BitProcess -eq $true)
{
    #64 bit
    $library = "C:\Oracle64\product\11.2.0\client_1\odp.net\managed\common\Oracle.ManagedDataAccess.dll"
}
else 
{
    #32 bit
    $library = "C:\app\client\PW82\product\12.1.0\client_4\odp.net\managed\common\Oracle.ManagedDataAccess.dll"
}

[void][Reflection.Assembly]::LoadFile($library)

#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

Export-ModuleMember -Function $Public.Basename