# QueryOracle
Powershell 5 module to enable working with Oracle instances using native powershell commands.

[13:58:11][C:\]# Import-Module QueryOracle    
[13:58:21][C:\]# $con = New-OracleConnection -Server $server -Credential $oracleCred  
[13:58:59][C:\]# $cmd = New-OracleCommand -Connection $con -CommandType Text -Query "select 'Hello world (from Oracle)!' from dual"  
[13:59:41][C:\]# $cmd.ExecuteScalar()  
Hello world (from Oracle)!  
[13:59:49][C:\]#
