<#
.Synopsis
   Executes a SQL query against an Oracle instance and returns the number of affected rows
.DESCRIPTION
   Takes an [Oracle.ManagedDataAccess.Client.OracleConnection] object and a sql query [string] and executes the query, returning the
   number of affected rows [int] or -1 if the query used the SELECT keyword.
   
   PowerShell implementation of Oracle.ManagedDataAccess.Client.OracleCommand.ExecuteNonQuery()
.EXAMPLE
   Invoke-OracleNonQuery -Connection $con -query "select MAX(managerID) from employees"
.EXAMPLE
   Invoke-OracleNonQuery -Connection $con -query "update employees set managerID = 51"
.EXAMPLE
   Invoke-OracleNonQuery -Command $cmd
#>
function Invoke-OracleNonQuery
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Oracle Connection Object [Oracle.ManagedDataAccess.Client.OracleConnection]
        [Parameter(ParameterSetName='ConnQuery', Mandatory=$true)]
        [Alias("C")]
        [Oracle.ManagedDataAccess.Client.OracleConnection]
        $Connection,

        # SQL query
        [Parameter(ParameterSetName='ConnQuery', Mandatory=$true)]
        [Alias("Q")]
        [string]$Query,

        # Oracle command object [Oracle.ManagedDataAccess.Client.OracleCommand]
        [Parameter(ParameterSetName='Command', Mandatory=$true)]
        [Alias("CMD")]
        [Oracle.ManagedDataAccess.Client.OracleCommand]
        $Command
    )

    try
    {
        #Check parameter set useage
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
        # Execute user supplied query and return affected rows count (or -1 for select query results)
        return $Command.ExecuteNonQuery()
    }
    catch { $_.Exception.Message }

}