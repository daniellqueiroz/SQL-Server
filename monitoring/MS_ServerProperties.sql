select @@servername

SELECT SERVERPROPERTY('MachineName') AS [MachineName], SERVERPROPERTY('ServerName') AS [ServerName],  
SERVERPROPERTY('InstanceName') AS [Instance], SERVERPROPERTY('IsClustered') AS [IsClustered], 
SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS [ComputerNamePhysicalNetBIOS], 
SERVERPROPERTY('Edition') AS [Edition], SERVERPROPERTY('ProductLevel') AS [ProductLevel], 
SERVERPROPERTY('ProductVersion') AS [ProductVersion], SERVERPROPERTY('ProcessID') AS [ProcessID],
SERVERPROPERTY('Collation') AS [Collation], SERVERPROPERTY('IsFullTextInstalled') AS [IsFullTextInstalled], 
SERVERPROPERTY('IsIntegratedSecurityOnly') AS [IsIntegratedSecurityOnly];



SELECT @@SERVERNAME AS [Server Name], create_date AS [SQL Server Install Date] 
FROM sys.server_principals WITH (NOLOCK)
WHERE name = N'NT AUTHORITY\SYSTEM'
OR name = N'NT AUTHORITY\NETWORK SERVICE' OPTION (RECOMPILE);


SELECT windows_release, windows_service_pack_level, 
       windows_sku, os_language_version
FROM sys.dm_os_windows_info WITH (NOLOCK) OPTION (RECOMPILE);


SELECT  
   CONNECTIONPROPERTY('net_transport') AS net_transport,
   CONNECTIONPROPERTY('protocol_type') AS protocol_type,
   CONNECTIONPROPERTY('auth_scheme') AS auth_scheme,
   CONNECTIONPROPERTY('local_net_address') AS local_net_address,
   CONNECTIONPROPERTY('local_tcp_port') AS local_tcp_port,
   CONNECTIONPROPERTY('client_net_address') AS client_net_address 
   
   