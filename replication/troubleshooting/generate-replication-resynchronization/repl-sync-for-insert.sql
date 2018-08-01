/********** 
EXECUTE ON PUBLISHER DATABASE, GETING THE OUTPUT AND EXECUTING ON THE SUBSCRIBER DATABASE. THIS WILL GENERATE THE REQUIRED SCRIPT SYNCHRONIZE RECORDS BETWEEN THE TWO DATABASES
THIS SCRIPT RELIES ON LINKED SERVER. MAKE SURE IT IS PROPERLY CONFIGURED AND THE NAMES OF SERVERS AND DATABASES ARE SET
***********/

USE DB_HOM_CORP_INTEGRACAO

SET NOCOUNT ON
GO
IF OBJECT_ID('tempdb..#inserts') IS NOT NULL
	DROP TABLE #inserts
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
	DROP TABLE #temp
GO
IF OBJECT_ID('tempdb..#tabelas') IS NOT NULL
	DROP TABLE #tabelas
GO

DECLARE @drops VARCHAR(MAX),@creates VARCHAR(MAX),@truncs VARCHAR(MAX), @tabelas VARCHAR(MAX)= 'audit_log_data';
DECLARE @tabela NVARCHAR(200)='',@campo NVARCHAR(300)='',@insert VARCHAR(MAX)='',@select VARCHAR(MAX)=''
,@cmd1 VARCHAR(MAX)='',@count VARCHAR(MAX)='',@campo1 VARCHAR(200)='',@countcampo TINYINT=0,@i TINYINT=0,@identity BIT=0
,@publicacao VARCHAR(50)='b2c_sku',@servidor VARCHAR(100),@banco VARCHAR(50)=DB_NAME()

SET @servidor =(SELECT QUOTENAME(@@servername))
IF @@servername ='sql-b2b-hlg01.dc.nova\b2b' SET @banco='db_hom_corp' ELSE IF @@servername ='CL-HL-DSQLWEB01\DSQLWEB01' SET @banco='db_des_corp' ELSE IF @@servername ='swat-hlg001' SET @banco='db_hom_corp_swat' 

CREATE TABLE #inserts (tabela VARCHAR(200),comando VARCHAR(MAX),inserti VARCHAR(MAX),Ordem TINYINT IDENTITY(1,1))
CREATE TABLE #temp (
ForeignKey_Name	sysname	not NULL,
Table_Name	sysname	not NULL,
CampoChave	VARCHAR(1000)	NULL,
TabelaReferenciada	VARCHAR(1000)	NULL,
CamposReferenciados	VARCHAR(1000)	NULL,
update_referential_action	tinyint	NULL,
delete_referential_action	tinyint	NULL)


SELECT DISTINCT
a.name tabela 
INTO #tabelas
FROM dbo.sysarticlecolumns ac
INNER JOIN sys.columns sc
ON ac.colid = sc.column_id
INNER JOIN dbo.sysarticles a
ON ac.artid = a.artid
AND a.name = OBJECT_NAME(sc.object_id)
INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
AND  i.object_id = sc.object_id
AND i.is_primary_key=1
--AND a.name='filial'
WHERE 1=1
--AND a.pubid IN (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)
AND a.name NOT IN 
	(
	SELECT DISTINCT tabela 
	FROM 
	(
		SELECT *,ROW_NUMBER() OVER(PARTITION BY tabela ORDER BY campo) AS rn
		FROM 
		(
			SELECT DISTINCT a.name tabela,sc.name campo
			FROM dbo.sysarticlecolumns ac
			INNER JOIN sys.columns sc
			ON ac.colid = sc.column_id
			INNER JOIN dbo.sysarticles a
			ON ac.artid = a.artid
			AND a.name = OBJECT_NAME(sc.object_id)
			INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
			INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
			INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
			AND  i.object_id = sc.object_id
			AND i.is_primary_key=1
			WHERE 1=1
			--AND a.pubid = (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)
			--and a.pubid = (select pubid from dbo.syspublications where name = 'corp_b2c')
		
		) AS a 
	) AS b WHERE rn>1
	)


DECLARE TabelasEleitas CURSOR FAST_FORWARD FOR
SELECT DISTINCT
'set nocount on; select count (*) as ''Count '+a.name+'''  from '+@servidor+'.'+@banco+'.dbo.' + a.name + ' c where not exists (select top 1 1 from ' + a.name + ' l where c.'+ sc.name + ' = l.'+ sc.name +')',
a.name tabela,sc.name campo
FROM dbo.sysarticlecolumns ac
INNER JOIN sys.columns sc
ON ac.colid = sc.column_id
INNER JOIN dbo.sysarticles a
ON ac.artid = a.artid
AND a.name = OBJECT_NAME(sc.object_id)
INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
AND  i.object_id = sc.object_id
AND i.is_primary_key=1
--AND a.name='Produto'
WHERE 1=1
--AND a.pubid = (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)

AND a.name NOT IN 

(
SELECT DISTINCT tabela 
FROM 
(
	SELECT *,ROW_NUMBER() OVER(PARTITION BY tabela ORDER BY campo) AS rn
	FROM 
	(
		SELECT DISTINCT a.name tabela,sc.name campo
		FROM dbo.sysarticlecolumns ac
		INNER JOIN sys.columns sc
		ON ac.colid = sc.column_id
		INNER JOIN dbo.sysarticles a
		ON ac.artid = a.artid
		AND a.name = OBJECT_NAME(sc.object_id)
		INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
		INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
		INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
		AND  i.object_id = sc.object_id
		AND i.is_primary_key=1
		WHERE 1=1
		--AND a.pubid = (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)
		--and a.pubid = (select pubid from dbo.syspublications where name = 'corp_b2c')
		
	) AS a 
) AS b WHERE rn>1
)

OPEN TabelasEleitas
FETCH NEXT FROM TabelasEleitas INTO @count,@tabela,@campo1
WHILE @@fetch_status<>-1
BEGIN
	
	SET @insert='print '''+ @tabela + '''; set nocount on;' 
	SET @identity=0

	SET @countcampo = (SELECT COUNT(DISTINCT sc.name)
	FROM dbo.sysarticlecolumns ac
	INNER JOIN sys.columns sc
	ON ac.colid = sc.column_id
	INNER JOIN dbo.sysarticles a
	ON ac.artid = a.artid
	AND a.name = OBJECT_NAME(sc.object_id)
	INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
	WHERE 1=1
	--AND a.pubid = (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)
	AND a.name=@tabela)

	IF EXISTS(SELECT OBJECT_NAME(object_id),* FROM sys.identity_columns WHERE name=@campo1 AND OBJECT_NAME(object_id)=@tabela)
	BEGIN
		SET @identity=1  
		SET @insert = @insert + 'set identity_insert ' + @tabela + ' on ' + CHAR(10) + CHAR(13) 
	END
    
	
	SET @insert=@insert + CHAR(10) + CHAR(13) + 'DECLARE @ROWCOUNT INT=1' + CHAR(10) + CHAR(13) + 'WHILE @ROWCOUNT>0' + CHAR(10) + CHAR(13) + 'BEGIN' + CHAR(10) + CHAR(13) + 'insert into ' + @tabela + '('  
	SET @select = 'select top (1000)'
	SET @i=0

	DECLARE campos CURSOR FOR
	
	SELECT DISTINCT
	sc.name campo
	FROM dbo.sysarticlecolumns ac
	INNER JOIN sys.columns sc
	ON ac.colid = sc.column_id
	INNER JOIN dbo.sysarticles a
	ON ac.artid = a.artid
	AND a.name = OBJECT_NAME(sc.object_id)
	INNER JOIN dbo.syspublications sp ON sp.pubid = a.pubid
	WHERE 1=1
	--AND a.pubid = (SELECT pubid FROM dbo.syspublications WHERE name = @publicacao)
	AND a.name=@tabela
	
	OPEN campos
	FETCH NEXT FROM campos INTO @campo
	WHILE @@fetch_status<>-1
	BEGIN
	SET @i=@i+1  

	--IF (@tabela='Produto' AND @campo IN ('_TextoMarca','_TextoCategoria','_TextoDepartamento')) -- CADASTRO DE EXCESSÕES
	--BEGIN
	--	PRINT 'Campo ' + @campo + ' na tabela ' + @tabela + ' está obsoleto ou é atualizado no assinante e logo foi desmarcado para inserção'
	--	FETCH NEXT FROM campos INTO @campo
	--END  
	--ELSE	
	BEGIN
		IF @countcampo != @i
		BEGIN
			SET @insert = @insert + @campo + ', '
			SET @select = @select + @campo + ', '
		END	
		ELSE
		BEGIN
			SET @insert = @insert + @campo
			SET @select = @select + @campo 
		END  
		FETCH NEXT FROM campos INTO @campo
	END
    END
		SET @select = @select + CHAR(13) + CHAR(10) + ' from '+@servidor+'.'+@banco+'.dbo.'+@tabela+' c where not exists (select top 1 1 from dbo.'+@tabela+' l where c.' + @campo1 + '=l.' + @campo1 + ')'
		SET @insert = @insert +  ') ' + CHAR(13) + CHAR(10) + @select 
	
		SET @insert = @insert + CHAR(10) + CHAR(13) +  'SET @ROWCOUNT=@@ROWCOUNT RAISERROR(''%d registros afetados.'',10,1,@rowcount) WITH nowait' + CHAR(10) + CHAR(13) + 'END' + CHAR(10)+CHAR(13)

		IF @identity =1 
		BEGIN
			SET @insert = @insert + CHAR(10) + CHAR(13) + 'set identity_insert ' + @tabela + ' off' 
		END
  
		SET @insert=@insert + CHAR(10)+CHAR(13) 

		INSERT INTO	#inserts (tabela, comando,inserti )
		SELECT @tabela,@insert,@count

		
	CLOSE campos
	DEALLOCATE campos
FETCH NEXT FROM TabelasEleitas INTO @count,@tabela,@campo1
END
CLOSE TabelasEleitas
DEALLOCATE TabelasEleitas

INSERT INTO #inserts
        ( tabela, comando, inserti )
VALUES  ( '', -- tabela - varchar(200)
          @creates + CHAR(10)+CHAR(13) + 'GO', -- comando - varchar(max)
          ''  -- inserti - varchar(max)
          )

SELECT * FROM #inserts ORDER BY Ordem




