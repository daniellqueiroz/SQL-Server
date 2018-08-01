SELECT @@SERVERNAME

BEGIN
DECLARE @description sysname;
                
SELECT 
    @description =  hars.role_desc
FROM 
    sys.DATABASES d
    INNER JOIN sys.dm_hadr_availability_replica_states hars ON d.replica_id = hars.replica_id
WHERE 
    database_id = DB_ID();
        
select @description;
    
END;

SELECT  
   CONNECTIONPROPERTY('net_transport') AS net_transport,
   CONNECTIONPROPERTY('protocol_type') AS protocol_type,
   CONNECTIONPROPERTY('auth_scheme') AS auth_scheme,
   CONNECTIONPROPERTY('local_net_address') AS local_net_address,
   CONNECTIONPROPERTY('local_tcp_port') AS local_tcp_port,
   CONNECTIONPROPERTY('client_net_address') AS client_net_address 