/********** 
EXECUTE ON PUBLISHER DATABASE, GETING THE OUTPUT AND EXECUTING ON THE SUBSCRIBER DATABASE. THIS WILL GENERATE THE REQUIRED SCRIPT SYNCHRONIZE RECORDS BETWEEN THE TWO DATABASES
THIS SCRIPT RELIES ON LINKED SERVER. MAKE SURE IT IS PROPERLY CONFIGURED AND THE NAMES OF SERVERS AND DATABASES ARE SET
***********/

SET NOCOUNT ON

declare @tabela nvarchar(200)='',@campo NVARCHAR(300)='',@insert VARCHAR(max)='',@select VARCHAR(MAX)=''
,@cmd1 VARCHAR(max)='',@count VARCHAR(MAX)='',@campo1 VARCHAR(200)='',@countcampo TINYINT=0,@i TINYINT=0,@identity BIT=0
,@publicacao VARCHAR(50)='marketplace_extra',@servidor VARCHAR(100),@banco VARCHAR(50)='db_prd_extra';

SET @servidor =(SELECT QUOTENAME(@@servername))
IF @@servername ='CL-HL-HSQLWEB01\HSQLWEB01' SET @banco='db_hom_corp' ELSE IF @@servername ='CL-HL-DSQLWEB01\DSQLWEB01' SET @banco='db_des_corp' ;

IF OBJECT_ID('tempdb..#inserts') IS NOT NULL
	DROP TABLE #inserts;

--CREATE TABLE #inserts (tabela VARCHAR(200),comando VARCHAR(max),inserti VARCHAR(max))

--DECLARE TabelasEleitas CURSOR FAST_FORWARD fOR
select distinct
 --'delete top (5000) from ' + a.name + ' l where not exists (select top 1 1 from '+@servidor+'.'+@banco+'.dbo.' + a.name + ' c where c.'+ sc.name + ' = l.'+ sc.name +')',
'set nocount on; select count (*) as ''Count '+a.NAME+'''  from '+@servidor+'.'+@banco+'.dbo.' + a.name + ' c where not exists (select top 1 1 from ' + a.name + ' l where c.'+ sc.name + ' = l.'+ sc.name +')',
a.name tabela,sc.name campo
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
AND i.is_primary_key=1
where 1=1
and a.pubid = (select pubid from dbo.syspublications where name = @publicacao)

AND a.name IN 

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
		AND a.name = object_name(sc.object_id)
		inner join dbo.syspublications sp on sp.pubid = a.pubid
		INNER JOIN sys.index_columns ic ON sc.column_id=ic.column_id
		INNER JOIN sys.indexes i ON ic.index_id = i.index_id AND ic.object_id = i.object_id
		and  i.object_id = sc.object_id
		AND i.is_primary_key=1
		where 1=1
		and a.pubid = (select pubid from dbo.syspublications where name = @publicacao)
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

	SET @countcampo = (SELECT COUNT(*)
	from dbo.sysarticlecolumns ac
	inner join sys.columns sc
	on ac.colid = sc.column_id
	inner join dbo.sysarticles a
	on ac.artid = a.artid
	AND a.name = object_name(sc.object_id)
	inner join dbo.syspublications sp on sp.pubid = a.pubid
	where 1=1
	and a.pubid = (select pubid from dbo.syspublications where name = @publicacao)
	AND a.name=@tabela)

	IF EXISTS(SELECT object_name(object_id),* FROM sys.identity_columns WHERE name=@campo1 AND object_name(object_id)=@tabela)
	BEGIN
		SET @identity=1  
		SET @insert = @insert + 'set identity_insert ' + @tabela + ' on ' + CHAR(10) + CHAR(13) 
	END
    
	
	SET @insert=@insert+'DECLARE @ROWCOUNT INT=1 WHILE @ROWCOUNT>0 BEGIN insert into ' + @tabela + '('  
	SET @select = 'select top (1000)'
	SET @i=0

	DECLARE campos CURSOR FOR
	
	select 
	sc.name campo
	from dbo.sysarticlecolumns ac
	inner join sys.columns sc
	on ac.colid = sc.column_id
	inner join dbo.sysarticles a
	on ac.artid = a.artid
	AND a.name = object_name(sc.object_id)
	inner join dbo.syspublications sp on sp.pubid = a.pubid
	where 1=1
	and a.pubid = (select pubid from dbo.syspublications where name = @publicacao)
	AND a.name=@tabela
	
	OPEN campos
	FETCH NEXT FROM campos INTO @campo
	WHILE @@fetch_status<>-1
	BEGIN
	SET @i=@i+1  

	IF (@tabela='Produto' AND @campo IN ('_TextoMarca','_TextoCategoria','_TextoDepartamento')) -- CADASTRO DE EXCESSÕES
	BEGIN
		PRINT 'Campo ' + @campo + ' na tabela ' + @tabela + ' está obsoleto ou é atualizado no assinante e logo foi desmarcado para inserção'
		FETCH NEXT FROM campos INTO @campo
	END  
	ELSE	
	begin
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
    end
		SET @select = @select + CHAR(13) + CHAR(10) + ' from '+@servidor+'.'+@banco+'.dbo.'+@tabela+' c where not exists (select top 1 1 from dbo.'+@tabela+' l where c.' + @campo1 + '=l.' + @campo1 + ')'
		SET @insert = @insert +  ') ' + CHAR(13) + CHAR(10) + @select 
	
		SET @insert = @insert +  'SET @ROWCOUNT=@@ROWCOUNT RAISERROR(''%d registros afetados.'',10,1,@rowcount) WITH nowait END' + CHAR(10)+CHAR(13) 

		IF @identity =1 
		begin
			SET @insert = @insert + CHAR(10) + CHAR(13) + 'set identity_insert ' + @tabela + ' off' 
		END
  
		SET @insert=@insert + CHAR(10)+CHAR(13) +'GO'  

		INSERT INTO	#inserts (tabela, comando,inserti )
		SELECT @tabela,@insert,@count
	
	CLOSE campos
	DEALLOCATE campos
FETCH NEXT FROM TabelasEleitas INTO @count,@tabela,@campo1
END
CLOSE TabelasEleitas
DEALLOCATE TabelasEleitas

SELECT * FROM #inserts


