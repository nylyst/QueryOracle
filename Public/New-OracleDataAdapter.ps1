<#
.Synopsis
   Creates a new [Oracle.ManagedDataAccess.Client.OracleDataAdapter] object
.DESCRIPTION
   Takes an [Oracle.ManagedDataAccess.Client.OracleCommand] object, returning an [Oracle.ManagedDataAccess.Client.OracleDataAdapter] object.
   
.EXAMPLE
   $da = New-OracleDataAdapter -Command $cmd
   $da.Fill($table)
#>
function New-OracleDataAdapter
{
    [CmdletBinding()]
    [OutputType([Oracle.ManagedDataAccess.Client.OracleDataAdapter])]
    Param
    (
        # Connection to an oracle server
        [Parameter(Mandatory=$true)]
        [Alias("C")]
        [Oracle.ManagedDataAccess.Client.OracleCommand]
        $Command
    )

    try
    {
        # Make sure $connection is open
        if($Command.Connection.State -ne [System.Data.ConnectionState]::Open)
        {
            $Command.Connection.Open()
        }
        
        [string]$query = $Command.CommandText
        [System.Data.CommandType]$cmdType = $Command.CommandType
        $Command.CommandText = "set role all"
        $Command.CommandType = [System.Data.CommandType]::Text
        $Command.ExecuteNonQuery() | Out-Null
        $Command.CommandType = $cmdType
        $Command.CommandText = $query
        [Oracle.ManagedDataAccess.Client.OracleDataAdapter]$da = New-Object Oracle.ManagedDataAccess.Client.OracleDataAdapter($Command)
        return [Oracle.ManagedDataAccess.Client.OracleDataAdapter]$da
    }
    catch { $_.Exception.Message }
}