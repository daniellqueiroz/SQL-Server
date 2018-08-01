-- run this script to generate a report about trigger details 

SELECT object_name(parent_id) AS Tabela,name
,CASE is_disabled WHEN 1 THEN 'Desativada' ELSE 'Ativada' END AS 'Status', CASE is_not_for_replication WHEN 1 THEN 'Não' ELSE 'Sim' END AS 'DisparaNaReplicacao?'
,(SELECT type_desc + ' | ' AS [data()] FROM sys.trigger_events te WHERE object_name(te.object_id)=t.name FOR XML PATH(''))  AS Eventos
,REPLACE(REPLACE(REPLACE(sm.definition,CHAR(13),SPACE(1)),CHAR(10),SPACE(1)),CHAR(9),'') AS Definicao
FROM SYS.triggers t INNER JOIN sys.sql_modules sm ON sm.object_id = t.object_id
WHERE is_ms_shipped=0
AND name NOT LIKE 'tr_[a-z]_audit%'
ORDER BY object_name(parent_id),name

/*
SELECT top 10 object_name(object_id),*, (SELECT type_desc + ' | ' AS [data()] FROM sys.trigger_events te WHERE object_name(te.object_id)=t.name FOR XML PATH(''))  AS Eventos
FROM sys.triggers t
*/

