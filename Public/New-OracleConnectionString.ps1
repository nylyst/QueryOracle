<#
.Synopsis
   Creates a new connection string using an [Oracle.ManagedDataAccess.Client.OracleConnectionStringBuilder] object
.DESCRIPTION
   Takes inputs: Server, User+Password (or a PSCredential object) and builds a connection string.  You can optionally specify $true/$false flags for several
   common connection string properties (e.g. pooling, connection validation)
.EXAMPLE
   New-OracleConnectionString -Server oracledb -User username -Pwd password
.EXAMPLE
   New-OracleConnectionString -Server oracledb -Credential $credential
#>
function New-OracleConnectionString
{
    [CmdletBinding()]
    [OutputType([string])]
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
        $Credential,

        # Connection Validation
        [bool]
        $ValidateConnection=$true,
        
        # Pooling
        [bool]
        $Pooling=$true,
        
        # Security Persistence
        [bool]
        $PersistSecurity=$true
    )

    $connectionString = "user id="

    if($PSCmdlet.ParameterSetName -eq "UserPass")
    {
        $connectionString += "$User;password=$Pass;data source=$Server"
    }
    else 
    {
        if($Credential.UserName.Contains('\')) 
        {
            $connectionString += $Credential.UserName.Split('\')[1]
        }
        else 
        {
            $connectionString += $Credential.UserName
        }
        $connectionString += ";password=" + $Credential.GetNetworkCredential().Password + ";data source=$Server"
    }

    try
    {
        $builder = New-Object Oracle.ManagedDataAccess.Client.OracleConnectionStringBuilder($connectionString)
        $builder.Add("validate connection", $ValidateConnection)
        $builder.Add("pooling", $Pooling)
        $builder.Add("persist security info", $PersistSecurity)

        return $builder.ConnectionString
    }
    catch { $_.Exception.Message }
}