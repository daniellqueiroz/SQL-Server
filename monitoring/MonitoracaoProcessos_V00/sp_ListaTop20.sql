if object_id('sp_ListaTop20') is not null
	drop PROCEDURE [dbo].[sp_ListaTop20]
go
create PROCEDURE [dbo].[sp_ListaTop20]
AS
BEGIN

SET NOCOUNT ON
	declare @OrderBy_Criteria varchar(128)
	set @OrderBy_Criteria = 'cpu'

	select DB_NAME(),GETDATE(),
		query_rank,
		execution_count,
		total_CPU_inMiliSeconds = qs.total_worker_time/1000,
		total_elapsed_time_inMiliSeconds = qs.total_elapsed_time/1000,
		--average_CPU_inMiliSeconds = (qs.total_worker_time/1000) / qs.execution_count,
		average_elapsed_time_imMiliSeconds = (qs.total_elapsed_time/1000 / qs.execution_count),
		last_elapsed_time/1000 AS DuracaoDaUltimaChamada,
		last_physical_reads,
		last_logical_reads,
		last_logical_writes,
		last_execution_time,
		--coalesce(object_name(qt.objectid),'1') ,
		case coalesce(object_name(qt.objectid),'1') 
			when '1' then REPLACE((qt.[text]),CHAR(13)+CHAR(10),' ') else object_name(qt.objectid)
		end as text
	from (select s.*, row_number() over(order by charted_value desc, last_execution_time desc) as query_rank from
			 (select *, 
					CASE @OrderBy_Criteria
						WHEN 'Logical Reads' then total_logical_reads
						WHEN 'Physical Reads' then total_physical_reads
						WHEN 'Logical Writes' then total_logical_writes
						WHEN 'CPU' then total_worker_time / 1000
						WHEN 'Duration' then total_elapsed_time / 1000
						WHEN 'CLR Time' then total_clr_time / 1000
					END as charted_value 
				from sys.dm_exec_query_stats) as s where s.charted_value > 0) as qs
		outer APPLY sys.dm_exec_sql_text(qs.sql_handle) AS	qt
		outer apply sys.dm_exec_query_plan (qs.plan_handle) AS qp
	where qs.query_rank <= 10     -- return only top 20 entries
	AND execution_count > 100

END