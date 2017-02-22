<#
.Synopsis
   Executes a SELECT query against an Oracle instance and returns the varchar value of the first column/row returned by the query.
.DESCRIPTION
   Takes an [Oracle.ManagedDataAccess.Client.OracleConnection] object and a SELECT query [string] and executes the query, returning the
   varchar value of the first column/row returned by the query.
   
   PowerShell implementation of Oracle.ManagedDataAccess.Client.OracleCommand.ExecuteScalar()
.EXAMPLE
   Invoke-OracleScalar -Connection $con -query "select 'SUCCESS!' from dual"
.EXAMPLE
   $employeeCount = Invoke-OracleScalar -Connection $con -query "select COUNT(*) from employees"
.EXAMPLE
   Invoke-OracleScalar -Command $cmd
#>
function Invoke-OracleScalar
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Oracle Connection Object [Oracle.ManagedDataAccess.Client.OracleConnection]
        [Parameter(ParameterSetName='ConnQuery', Mandatory=$true)]
        #[Alias("C")]
        [Oracle.ManagedDataAccess.Client.OracleConnection]
        $Connection,

        # SQL query
        [Parameter(ParameterSetName='ConnQuery', Mandatory=$true)]
        #[Alias("Q")]
        [string]$Query,

        # Oracle command object [Oracle.ManagedDataAccess.Client.OracleCommand]
        [Parameter(ParameterSetName='Command', Mandatory=$true)]
        [Alias("CMD")]
        [Oracle.ManagedDataAccess.Client.OracleCommand]
        $Command
    )

    try
    {
        if($PSCmdlet.ParameterSetName -eq "ConnQuery")
        {
            # Make sure $connection is open
            if($Connection.State -ne [System.Data.ConnectionState]::Open)
            {
                $Connection.Open()
            }
            # Build Oracle.ManagedDataAccess.Client.OracleCommand object
            $Command = New-OracleCommand -Connection $Connection -CommandType Text -query $query
        }
        else 
        {
            if($Command.Connection.State -ne [System.Data.ConnectionState]::Open)
            {
                $Command.Connection.Open()
            }
        }        
        # Execute user supplied query and return scalar result (first column value of first row returned)
        return $Command.ExecuteScalar()
    }
    catch { $_.Exception.Message }
}