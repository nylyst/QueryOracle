# QueryOracle
Powershell 5 module to enable working with Oracle instances using native powershell commands.

Currently requires the user to locate their 32/64 bit ODP.Net assemblies and update QueryOracle.psm1.  Future enhancements will include finding the users %ORACLE_HOME% (or inspecting %PATH) and loading the assemblies automatically.


[13:58:11][C:\]# Import-Module QueryOracle    
[13:58:21][C:\]# $con = New-OracleConnection -Server $server -Credential $oracleCred  
[13:58:59][C:\]# $cmd = New-OracleCommand -Connection $con -CommandType Text -Query "select 'Hello world (from Oracle)!' from dual"  
[13:59:41][C:\]# $cmd.ExecuteScalar()  
Hello world (from Oracle)!  
[13:59:49][C:\]# $cmd.CommandText = "select max(employeeID) from employees"  
[14:00:53][C:\]# $cmd.ExecuteScalar()  
123456  
[14:06:03][C:\]# $cmd.CommandText = "select parentID, childID, effective_date from example_table"  
[14:13:03][C:\]# $da = New-OracleDataAdapter -Command $cmd  
[14:13:36][C:\]# $table = New-Object System.Data.DataTable  
[14:13:51][C:\]# $da.Fill($table)  
14  
[14:13:56][C:\]# $table | format-table -AutoSize  

PARENTID CHILDID EFFECTIVE_DATE  
-------- ------- -------------------  
12942    11931   1/26/2017  
12942    11929   1/26/2017  
12942    11785   1/26/2017  
12942    11784   1/26/2017  
12942    11783   1/26/2017  
12942    11782   1/26/2017  
12942    11781   1/26/2017  
12942    11780   1/26/2017  
12942    11779   1/26/2017  
12942    11778   1/26/2017  
12942    11777   1/26/2017  
12942    11776   1/26/2017  
12942    11775   1/26/2017  
12942    11774   1/26/2017  
