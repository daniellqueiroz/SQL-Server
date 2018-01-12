USE master;
GO

CREATE PROC [dbo].[proc_kill_processes_por_database]
@dbname VARCHAR(250)
AS

DECLARE @pid INT;
DECLARE @cmd NVARCHAR(1000);

DECLARE cursor1 CURSOR FOR
SELECT spid FROM master..sysprocesses
WHERE DB_NAME(dbid) = @dbname
AND dbid <> 0
AND spid > 50;
         
         
OPEN cursor1;  
FETCH NEXT FROM cursor1 INTO @pid;  

WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @cmd = 'kill '+CAST(@pid AS VARCHAR(15));
       EXEC sp_executesql @cmd;
      
FETCH NEXT FROM cursor1 INTO @pid;
END;   

CLOSE cursor1;   
DEALLOCATE cursor1; 
