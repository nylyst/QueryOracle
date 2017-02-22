<#
.Synopsis
   Executes SELECT query against an Oracle instance and returns and [Oracle.ManagedDataAccess.Client.OracleDataReader] object
.DESCRIPTION
   Takes an [Oracle.ManagedDataAccess.Client.OracleConnection] object and a SELECT query [string] and executes the query, returning an
   [Oracle.DataaAccess.Client.OracleDataReader] object
   
   Results are returned as an array of System.Data.Common.DbDataRecord Objects, where the length of the array is the row count
   Individual fields are accessed as before with the OracleDataReader: $reader[0].Getxxx(index) where xxx is the type and index is the column index
   
   PowerShell implementation of Oracle.ManagedDataAccess.Client.OracleCommand.ExecuteReader()
.EXAMPLE
   Invoke-OracleReader -Connection $con -query "select ID, firstname, lastname, managerID from employees"
.EXAMPLE
   Invoke-OracleReader -Connection $con -query "select ID, firstname, lastname, managerID from employees where department=21"
.EXAMPLE
   Invoke-OracleReader -Command $cmd
#>
function Invoke-OracleReader
{
    [CmdletBinding()]
    [OutputType([Oracle.ManagedDataAccess.Client.OracleDataReader])]
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
        [string]
        $Query,

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
            $Command = New-OracleCommand -Connection $Connection -CommandType Text -Query $query
        }
        else 
        {
            if($Command.Connection.State -ne [System.Data.ConnectionState]::Open)
            {
                $Command.Connection.Open()
            }
        }
        # Execute user supplied query and return query results.
        return $Command.ExecuteReader()
    }
    catch { $_.Exception.Message }
}