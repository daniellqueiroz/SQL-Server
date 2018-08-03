DECLARE @DeleteDate DATETIME = DATEADD(DAY,-21,GETDATE());
EXEC master.sys.xp_delete_file 0,'S:\DB_Backups\sys\','bak',@DeleteDate,0;