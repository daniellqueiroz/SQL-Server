/********** 
EXECUTE ON PUBLISHER DATABASE, GETING THE OUTPUT AND EXECUTING ON THE SUBSCRIBER DATABASE. THIS WILL GENERATE THE REQUIRED SCRIPT SYNCHRONIZE RECORDS BETWEEN THE TWO DATABASES
THIS SCRIPT RELIES ON LINKED SERVER. MAKE SURE IT IS PROPERLY CONFIGURED AND THE NAMES OF SERVERS AND DATABASES ARE SET
***********/

USE DB_HOM_CORP_INTEGRACAO

DECLARE @publicacao VARCHAR(200)='B2C_Sku',@servidor VARCHAR(100),@banco VARCHAR(50)=DB_NAME()
SET @servidor =(SELECT QUOTENAME(@@servername))
--IF @@servername ='CL-HL-HSQLWEB01\HSQLWEB01' SET @banco='db_hom_corp' ELSE IF @@servername ='CL-HL-DSQLWEB01\DSQLWEB01' SET @banco='db_des_corp' 

IF OBJECT_ID('tempdb..#chaves') IS NOT NULL
DROP TABLE #chaves;

select 
distinct
a.name tabela,sc.name campo
into #chaves 
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

select distinct a.name, sc.name 
, 'set nocount on; select count(*) as ''COUNT '+sc.NAME+''''+' from ' + a.name + ' c inner join '+@servidor+'.'+@banco+'.dbo.' + a.name +
' l on c.id' + a.NAME + '=l.id'+a.NAME + ' where (isnull('+ CASE WHEN sc.system_type_id IN (35,99) THEN 'cast(c.'+sc.NAME+ ' as varchar(max)) ' ELSE 'c.'+sc.NAME END +','+ 
CASE WHEN sc.system_type_id IN (42,43,58,61) THEN '''1990-01-01''' WHEN sc.system_type_id IN (35,99,231,239,175,167,99) THEN '''''' 
ELSE '0' END +') != isnull(l.' + sc.name + ',' + CASE WHEN sc.system_type_id IN (42,43,58,61) THEN '''1990-01-01''' WHEN sc.system_type_id IN (35,99,231,239,175,167,99) THEN '''''' WHEN sc.system_type_id IN (41) then '''00:00:00''' ELSE '0' END
+')) or (c.'+sc.name+ ' is null and l.'+sc.name+' is not null ) or (c.'+sc.name+ ' is not null and l.'+sc.name+' is null )'

,'select top 1 c.id' +a.NAME + ' from ' + a.name + ' c inner join '+@servidor+'.'+@banco+'.dbo.' + a.name +
' l on c.id' + a.NAME + '=l.id'+a.NAME + ' where isnull(c.'+sc.NAME+ ','+ 
CASE WHEN sc.system_type_id IN (42,43,58,61) THEN '''1990-01-01''' WHEN sc.system_type_id IN (35,99,231,239,175,167,99) THEN '''''' ELSE '0' END +') != isnull(l.' + sc.name + ',' + CASE WHEN sc.system_type_id IN (42,43,58,61) THEN '''1990-01-01''' WHEN sc.system_type_id IN (35,99,231,239,175,167,99) THEN '''''' WHEN sc.system_type_id IN (41) then '''00:00:00''' ELSE '0' END+')'

,'set nocount on; DECLARE @ROWCOUNT INT=1 WHILE @ROWCOUNT>0 BEGIN update top (1000)' + a.name + ' set ' + sc.name + ' = ' + ' c.' +sc.name + ' from ' + a.name + ' l inner join '+@servidor+'.'+@banco+'.dbo.' + a.name +
' c on c.' + (SELECT campo FROM #chaves WHERE tabela=a.name) + '=l.'+ (SELECT campo FROM #chaves WHERE tabela=a.name) + ' where (isnull('+ 

CASE WHEN sc.system_type_id IN (35,99) THEN 'cast(c.'+sc.NAME+ ' as varchar(max)) ' ELSE 'c.'+sc.NAME END +','+ 

CASE WHEN sc.system_type_id IN (42,43,58,61) THEN '''1990-01-01''' WHEN sc.system_type_id IN (35,99,231,239,175,167,99) THEN '''''' WHEN sc.system_type_id IN (41) then '''00:00:00''' ELSE '0' END +') != isnull('+ CASE WHEN sc.system_type_id IN (35,99) THEN 'cast(l.'+sc.NAME+ ' as varchar(max)) ' 

ELSE 'l.'+sc.NAME END +','+  CASE WHEN sc.system_type_id IN (42,43,58,61) THEN '''1990-01-01''' WHEN sc.system_type_id IN (35,99,231,239,175,167,99) THEN '''''' WHEN sc.system_type_id IN (41) then '''00:00:00''' ELSE '0' END
+')) or (c.'+sc.name+ ' is null and l.'+sc.name+' is not null ) or (c.'+sc.name+ ' is not null and l.'+sc.name+' is null ) SET @ROWCOUNT=@@ROWCOUNT RAISERROR(''%d registros afetados.'',10,1,@rowcount) WITH nowait END print ''' + a.NAME + ',' +sc.name+ '''' + CHAR(10)+CHAR(13) + 'GO' + CHAR(10)+CHAR(13)

from dbo.sysarticlecolumns ac
inner join sys.columns sc
on ac.colid = sc.column_id
inner join dbo.sysarticles a
on ac.artid = a.artid
and a.name = object_name(sc.object_id)
inner join dbo.syspublications sp
on sp.pubid = a.pubid


where 1=1
and a.pubid = (select pubid from dbo.syspublications where name = @publicacao)
--AND a.name IN ('formapagamento','administrador')
AND sc.name NOT IN ('IdAdministradorAprovado','IdAdministradorEdicao')
AND NOT EXISTS ( SELECT TOP 1 1 FROM sys.identity_columns sic WHERE sic.name=sc.name AND object_name(object_id)=a.name)
AND a.NAME+sc.name NOT IN ('Produto_TextoMarca','Produto_TextoCategoria','Produto_TextoDepartamento','ProdutoCampoValorTexto','ProdutoDataEdicao','SkuDataCadastro','ProdutoDataAprovado','ProdutoDataAtualizacao','ProdutoDataLancamento','ProdutoIdProdutoEdicao','ProdutoTituloComercialAlternativo','Produto_MaisVendidos')
--and a.name='paginacandidato'
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
