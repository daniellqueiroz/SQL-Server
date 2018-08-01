-- use this technique to slowly update data in big tables.
-- this strategy is preferrable since it reduces the likelyhood of causing contention and concurrency problems in the database
-- note that the scripts uses a limit of 4000 records affected based on the behavior of Lock Escalation within SQL Server

SET NOCOUNT ON
DECLARE @count INT,@top INT=4000
SELECT @count = COUNT(*) FROM Cliente WHERE DataUltimaAtualizacao IS NULL
WHILE @count > 0
BEGIN
	UPDATE TOP (@top) Cliente SET DataUltimaAtualizacao=GETDATE() WHERE DataUltimaAtualizacao IS NULL
	SET @count = @count - @top
	RAISERROR('faltam %d registros',0,1,@count) WITH NOWAIT	
	WAITFOR DELAY '00:00:01'
END
