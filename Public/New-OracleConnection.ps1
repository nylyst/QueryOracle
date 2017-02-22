<#
.Synopsis
   Creates a new [Oracle.ManagedDataAccess.Client.OracleConnection] object
.DESCRIPTION
   Takes 3 strings: Server, User and Pwd and returns an [OracleDataAccess.Client.OracleConnection] object.  
.EXAMPLE
   New-OracleConnection -Server oracledb -User username -Pwd password
.EXAMPLE
   $conn = New-OracleConnection -Server testdb -User username -Pwd password
#>
function New-OracleConnection
{
    [CmdletBinding()]
    [OutputType([Oracle.ManagedDataAccess.Client.OracleConnection])]
    Param
    (
        # Server TNS name (as stored in your TNSNames.ora file)
        [Parameter(Mandatory=$true)]
        [Alias("Database", "IP", "S")]
        [string]
        $Server,

        # Plaintext username
        [Parameter(ParameterSetName='UserPass', Mandatory=$true)]
        [Alias("Username", "U", "Name")]
        [string]
        $User,

        # SecureString encrypted password
        [Parameter(ParameterSetName='UserPass', Mandatory=$true)]
        [Alias("P")]
        [SecureString]
        $Password,

        # PSCredential Object with username/password
        [Parameter(ParameterSetName='Credential', Mandatory=$true)]
        [Alias("Cred")]
        [PSCredential]
        $Credential
    )

    try
    {
        if($PSCmdlet.ParameterSetName -eq "UserPass")
        {
            $connectString = (New-OracleConnectionString -Server $Server -User $User -Password $Pass)
        }
        else 
        {
            $connectString = (New-OracleConnectionString -Server $Server -Credential $Credential)
        }
        [Oracle.ManagedDataAccess.Client.OracleConnection]$connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectString)
        return $connection
    }
    catch 
    {
        Write-Error $_.Exception 
    }
}