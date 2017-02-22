<#
.Synopsis
   Creates a new [Oracle.ManagedDataAccess.Client.OracleCommand] object
.DESCRIPTION
   Takes an [Oracle.ManagedDataAccess.Client.OracleConnection] object, [System.Data.CommandType] enum value and a SQL query string and
   returns a an [Oracle.ManagedDataAccess.Client.OracleCommand] object.  You can also specify a role to enable, if omitted, the command
    
        set role all
   
   will be executed before the specified query
.EXAMPLE
   New-OracleCommand -Connection $con -CommandType Text -Query "select 1 from dual"
.EXAMPLE
   $cmd = New-OracleCommand - Connection $con -CommandType Text -Query "select 'fe fi fo fum' from dual"
#>
function New-OracleCommand
{
    [CmdletBinding()]
    [OutputType([Oracle.ManagedDataAccess.Client.OracleCommand])]
    Param
    (
        # Connection to an oracle server
        [Parameter(Mandatory=$true)]
        [Alias("C")]
        [Oracle.ManagedDataAccess.Client.OracleConnection]
        $Connection,

        # Type of sql command
        [Parameter(Mandatory=$true)]
        [Alias("T", "Type")]
        [System.Data.CommandType]
        $CommandType,

        # SQL statement
        [Parameter(Mandatory=$true)]
        [Alias("Q")]
        [string]
        $Query,
        
        # Role to enable, all if ommitted
        [Parameter(Mandatory=$false)]
        #[Alias("R")]
        [string]
        $Role='all'
    )

    try
    {
        # Make sure $connection is open
        if($Connection.State -ne [System.Data.ConnectionState]::Open)
        {
            $Connection.Open()
        }
        
        $cmd = New-Object Oracle.ManagedDataAccess.Client.OracleCommand
        $cmd.Connection = $Connection
        $cmd.CommandType = $CommandType
        $cmd.CommandText = "set role $Role"
        $cmd.ExecuteNonQuery() | Out-Null

        $cmd.CommandText = $query
        return $cmd
    }
    catch { $_.Exception.Message }
}