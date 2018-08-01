/********** 
EXECUTE ON PUBLISHER DATABASE, GETING THE OUTPUT AND EXECUTING ON THE SUBSCRIBER DATABASE. THIS WILL GENERATE THE REQUIRED SCRIPT SYNCHRONIZE RECORDS BETWEEN THE TWO DATABASES
THIS SCRIPT RELIES ON LINKED SERVER. MAKE SURE IT IS PROPERLY CONFIGURED AND THE NAMES OF SERVERS AND DATABASES ARE SET
***********/


DECLARE @publicacao VARCHAR(200)='B2C_Arquivo' -- publication name here
,@servidor VARCHAR(100),@banco VARCHAR(50)='db_prd_corp' --publisher db here

SET @servidor =(SELECT QUOTENAME(@@servername))
IF @@servername ='CL-HL-HSQLWEB01\HSQLWEB01' SET @banco='db_hom_corp' ELSE IF @@servername ='CL-HL-DSQLWEB01\DSQLWEB01' SET @banco='db_des_corp' --dinamically setting the publisher db based on environment


select distinct
 'set nocount on; DECLARE @ROWCOUNT INT=1 WHILE @ROWCOUNT>0 BEGIN delete top (1000) ' + a.name + ' from ' + a.name + ' l where not exists (select top 1 1 from [CORP_PRD.dc.nova,1310].'+@banco+'.dbo.' + a.name + ' c where c.'+ sc.name + ' = l.'+ sc.name +') SET @ROWCOUNT=@@ROWCOUNT RAISERROR(''%d registros afetados.'',10,1,@rowcount) WITH nowait END' + CHAR(10)+CHAR(13) + ' GO' + CHAR(10)+CHAR(13)
, 'set nocount on; select count (*) as ''Count '+a.NAME+''' from ' + a.name + ' l where not exists (select top 1 1 from [CORP_PRD.dc.nova,1310].'+@banco+'.dbo.' + a.name + ' c where c.'+ sc.name + ' = l.'+ sc.name +')'
,a.name tabela,sc.name campo,i.is_primary_key
from dbo.sysarticlecolumns ac
inner join sys.columns sc
on ac.colid = sc.column_id
inner join dbo.sysarticles a
on ac.artid = a.artid
AND a.name = object_name(sc.object_id)
inner join dbo.syspublications sp on sp.pubid = a.pubid
INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
and  i.object_id = sc.object_id
where 1=1
and a.pubid = (select pubid from dbo.syspublications where name = @publicacao)
AND i.is_primary_key=1
AND a.name NOT IN 

(
SELECT DISTINCT tabela 
FROM 
(
	SELECT *,ROW_NUMBER() OVER(PARTITION BY tabela ORDER BY campo) AS rn
	FROM 
	(
		select distinct a.name tabela,sc.name campo
		from dbo.sysarticlecolumns ac
		inner join sys.columns sc
		on ac.colid = sc.column_id
		inner join dbo.sysarticles a
		on ac.artid = a.artid
		and a.name = object_name(sc.object_id)
		inner join dbo.syspublications sp on sp.pubid = a.pubid
		INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
		INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
		and  i.object_id = sc.object_id
		where 1=1
		and a.pubid = (select pubid from dbo.syspublications where name = @publicacao)
		AND i.is_primary_key=1
	) AS a 
) AS b WHERE rn>1
)


/*
SELECT * FROM sys.key_constraints

SELECT * FROM (
SELECT i.name indice,c.name, ROW_NUMBER() OVER(PARTITION BY i.name ORDER BY (SELECT 0)) as rn
FROM sys.index_columns ic
INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id --
INNER JOIN sys.columns c ON i.object_id = c.object_id --
AND c.column_id=ic.column_id --
WHERE i.is_primary_key=1
) AS b WHERE rn=1

SELECT TOP 1000 * FROM dbo.syspublications
SELECT TOP 10 * FROM dbo.syssubscriptions

*/

