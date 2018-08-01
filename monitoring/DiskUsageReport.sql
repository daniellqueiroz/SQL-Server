
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;
DECLARE @tran_log_space_usage table( 
        database_name sysname
,       log_size_mb float
,       log_space_used float
,       status int
); 
INSERT INTO @tran_log_space_usage 
EXEC('DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS');
 
SELECT 
    database_name,
    log_size_mb,
    log_space_used,
    status    
FROM @tran_log_space_usage



DECLARE @dbsize bigint 
DECLARE @logsize bigint 
DECLARE @ftsize bigint 
DECLARE @reservedpages bigint 
DECLARE @pages bigint 
DECLARE @usedpages bigint

SELECT @dbsize = SUM(convert(bigint,case when type = 0 then size else 0 end)) 
      ,@logsize = SUM(convert(bigint,case when type = 1 then size else 0 end)) 
      ,@ftsize = SUM(convert(bigint,case when type = 4 then size else 0 end)) 
FROM sys.database_files

SELECT @reservedpages = SUM(a.total_pages) 
       ,@usedpages = SUM(a.used_pages) 
       ,@pages = SUM(CASE 
                        WHEN it.internal_type IN (202,204) THEN 0 
                        WHEN a.type != 1 THEN a.used_pages 
                        WHEN p.index_id < 2 THEN a.data_pages 
                        ELSE 0 
                     END) 
FROM sys.partitions p  
JOIN sys.allocation_units a ON p.partition_id = a.container_id 
LEFT JOIN sys.internal_tables it ON p.object_id = it.object_id 

SELECT 
        @dbsize as 'dbsize',
        @logsize as 'logsize',
        @ftsize as 'ftsize',
        @reservedpages as 'reservedpages',
        @usedpages as 'usedpages',
        @pages as 'pages'


--------------------------------------------------------------------------------
