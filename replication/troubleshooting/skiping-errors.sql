-- This script is not yet done

--EXEC sp_replflush
GO

DBCC OPENTRAN
GO

SELECT TOP 1000  [Current LSN],Operation,[Transaction ID],[Article ID] ,
        [Begin Time] ,        Command ,        [Command Type] ,        [Database Name] ,
        [End Time] ,        [Publication ID] ,        [Server Name] ,        SPID  
FROM fn_dblog('129:136:303', NULL) 
WHERE 1=1
--and[Begin Time] > '2012/03/05T06:00:48:343' AND [Begin Time] < '2012/03/05T07:00:48:343'
--AND [Current LSN] like '0003de33:00020784%'
ORDER BY [Begin Time] DESC

