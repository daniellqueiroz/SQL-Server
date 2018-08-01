-- run the script below to get a fragmentation overview of a specific table
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('ColecaoParametroProduto'),NULL,NULL,NULL)

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('ColecaoParametroProduto')

-- run the command below to get a overview of page density and fragmentation for a particular table
DBCC SHOWCONTIG('ColecaoParametroProduto')

-- tirando plano de proc do cache (pegar plan handle a partir da query acima)
--DBCC FREEPROCCACHE(0x05000500C990810040E319AB0F0000000000000000000000)

-- getting missing index advantage
SELECT * 
FROM 
(SELECT user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) AS 
index_advantage, migs.* FROM sys.dm_db_missing_index_group_stats migs) AS 
migs_adv 
INNER JOIN sys.dm_db_missing_index_groups AS mig 
    ON migs_adv.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid 
    ON mig.index_handle = mid.index_handle
WHERE 1=1
--AND migs_adv.index_advantage > 10000 -- specify the advantage threshold here
ORDER BY migs_adv.index_advantage
