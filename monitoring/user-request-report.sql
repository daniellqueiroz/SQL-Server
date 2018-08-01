	select count(r.request_id) as num_requests,
		sum(convert(bigint, r.total_elapsed_time)) as total_elapsed_time,
		sum(convert(bigint, r.cpu_time)) as cpu_time,
		sum(convert(bigint, r.total_elapsed_time)) - sum(convert(bigint, r.cpu_time)) as wait_time,
		case when sum(r.logical_reads) > 0 then (sum(r.logical_reads) - isnull(sum(r.reads), 0)) / convert(float, sum(r.logical_reads))
			else NULL
			end as cache_hit_ratio
	from sys.dm_exec_requests r
		join sys.dm_exec_sessions s on r.session_id = s.session_id
	where s.is_user_process = 0x1

--EXEC dbo.sp_whoisactive 
