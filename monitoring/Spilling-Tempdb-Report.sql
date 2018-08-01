select num_of_reads, num_of_bytes_read,

num_of_writes, num_of_bytes_written

from sys.dm_io_virtual_file_stats(db_id('tempdb'), 1)

go

 

--Query to monitor requests (similar to activity monitor)

--Example provided by www.sqlworkshops.com

select status, wait_type

from sys.dm_exec_requests

where session_id = ??

go

 

--Query to monitor memory grants

--Example provided by www.sqlworkshops.com

select granted_memory_kb, used_memory_kb, max_used_memory_kb

from sys.dm_exec_query_memory_grants

where session_id = ??

go
