SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
--select * from dadosconfiguracao where nome='ColecoesOfertarEntregaExpressa'



--exec gerascript 'dadosconfiguracao','iddadosconfiguracao=674',10,'','','','','',''
--GO


ALTER PROCEDURE [dbo].[GeraScript] (  
 @p_tbl_verifica  VARCHAR(50),  
 @condicao   VARCHAR(500)= NULL,
@top INT=2000000000,   
 @campoIgnorado  VARCHAR(100) = NULL,  
 @campoIgnorado2  VARCHAR(100)= NULL,
@campoIgnorado3 VARCHAR(100)= NULL
,@campoIgnorado4 VARCHAR(100)= NULL
,@campoIgnorado5 VARCHAR(100)= NULL
,@campoIgnorado6 VARCHAR(100)= NULL
)  
--/************************************************************************  
--* Data:  22/12/2009  
--* Autor:  Francisco Amarante  
--* Versão:  5.2 - corrigido problemas de collation e aspas simples nos campos do tipo varchar e text  
--* CoAutor: Rafael Bahia (rafaelbahialde@gmail.com)  
--* Parametro1: Nome da tabela, ou parte do nome como filtro ou NULL para todas as tabelas  
--* Parametro2: Condição de filtragem para as tabelas (Ex: CodCurso = 1). NULL para omitir filtragem  
--* Parâmetro3: Primeiro campo a ser rejeitado na geração do script. Alguns campos possuem tipos de dados cujos valores não podem ser tratados como string, impossibilitando a carga de forma correta. Esses campos são ignorados.  
--* Parâmetro4: Ver descrição para parâmetro anterior  
--*************************************************************************/  
AS  
SET NOCOUNT ON
DECLARE @collation_default VARCHAR(50)  
 DECLARE @identity TINYINT 
 SET @collation_default = (SELECT CONVERT(VARCHAR,DATABASEPROPERTYEX( DB_NAME() , 'Collation' )))  
 DECLARE Cur_Tabs_Campos CURSOR FOR  
 SELECT  
  T.name,  
  C.name,  
  ( CASE C.type  
   WHEN 39 THEN 'C'  
   WHEN 47 THEN 'C'  
   WHEN 61 THEN 'D'  
   WHEN 58 THEN 'D'  
   WHEN 111 THEN 'D'  
   WHEN 37 THEN 'V'  
   WHEN 35 THEN 'T'  
   ELSE 'N'  
  END)  
 FROM  
  sysobjects T,  
  syscolumns C  
 WHERE  
  T.id = C.id AND  
  --  
  T.type = 'u' AND  
  ( CASE  
   WHEN @p_tbl_verifica IS NULL THEN 1  
   WHEN T.name = @p_tbl_verifica THEN 1  
   WHEN T.name LIKE @p_tbl_verifica THEN 1  
   ELSE 0  
  END) = 1  
 --order by 1, 2  
 CREATE TABLE #Tab ( QInsert VARCHAR(MAX))  
 DECLARE @v_tbl_aux  VARCHAR(50)  
 DECLARE @v_tbl   VARCHAR(50)  
 DECLARE @v_campo  VARCHAR(50)  
 DECLARE @v_tipo   CHAR(1)  
 DECLARE @v_sql1   VARCHAR(MAX)  
 DECLARE @v_sql2   VARCHAR(MAX)  
 DECLARE @v_campoaux     VARBINARY  
BEGIN  
 OPEN Cur_Tabs_Campos  
 FETCH NEXT FROM Cur_Tabs_Campos  
 INTO  
  @v_tbl,  
  @v_campo,  
  @v_tipo  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  SET @v_sql1 = ''  
  SET @v_sql2 = ''  
  SET @v_tbl_aux = @v_tbl  
    
  WHILE @@FETCH_STATUS = 0 AND @v_tbl_aux = @v_tbl  
  BEGIN  
  SELECT @identity = COUNT(*) FROM sys.identity_columns WHERE OBJECT_NAME(object_id) = @v_tbl_aux
                
                --SELECT OBJECT_NAME(object_id),* FROM sys.identity_columns
                
   IF @v_campo <> @campoIgnorado AND @v_campo <> @campoIgnorado2  AND @v_campo <> @campoIgnorado3 AND @v_campo <> @campoIgnorado4 AND @v_campo <> @campoIgnorado5 AND @v_campo <> @campoIgnorado6
   BEGIN  
    IF @v_sql1 <> ''  
     SET @v_sql1 = @v_sql1 + ', '  
      
    SET @v_sql1 = @v_sql1 + @v_campo  
      
    IF @v_sql2 <> ''  
     SET @v_sql2 = @v_sql2 + ' + '  
    IF @v_tipo = 'N'  
     SET @v_sql2 = @v_sql2 + 'isnull ( convert ( varchar, ' + @v_campo + '), ''NULL'') + '', '''  
    ELSE IF @v_tipo = 'D'  
     SET @v_sql2 = @v_sql2 + ''''''''' + ' + 'isnull ( convert ( varchar, ' + @v_campo + '), ''NULL'') + '''''', '''  
    -- Caso em que o tipo de campo é varbinary. Neste caso a conversão para varchar para possível concatenação deve ser feita pela função fn_varbintohexstr  
    ELSE IF @v_tipo = 'V'  
    BEGIN  
     SET @v_sql2 = @v_sql2 + ''''''''' + ' + 'isnull ( convert ( nvarchar(50), ' + @v_campo + '), ''NULL'') + '''''', '''   
     --set @v_campoaux = 'isnull ( cast ' + @v_campo + ' as varbinary), ''NULL'') + '', '''  
     --set @v_sql2 = @v_sql2 + @v_campoaux + ' + '''''', '''  
    END  
    ELSE IF @v_tipo = 'T'  
     -- Nos casos em que o campo é do tipo de dados text, é preciso converter o campo para varchar para que seja possível fazer a concatenação  
     SET @v_sql2 = @v_sql2 + ''''''''' + ' + 'isnull ( replace(convert ( varchar(max), ' + @v_campo + '),'''''''',''''''''''''), ''NULL'') + '''''', '''  
    ELSE  
	BEGIN  
     IF ((SELECT COLLATION_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @v_tbl_aux AND DATA_TYPE = 'varchar' AND COLUMN_NAME = @v_campo) <>  @collation_default)  
     BEGIN  
      PRINT @v_campo;  
      SET @v_sql2 = @v_sql2 + ''''''''' + isnull ( replace(convert ( varchar , ' + @v_campo + ' COLLATE ' + @collation_default + '),'''''''',''"''), ''NULL'') + '''''', '''  
      --set @v_sql2 = @v_sql2 + ''''''''' + isnull ( ' + @v_campo + ', ''NULL'') + '''''', '''  
     END  
     ELSE  
     BEGIN  
      --print @v_campo;  
      SET @v_sql2 = @v_sql2 + ''''''''' + isnull ( replace(' + @v_campo + ','''''''',''''''''''''), ''NULL'') + '''''', '''  
     END  
    END  
   END  
   FETCH NEXT FROM Cur_Tabs_Campos  
   INTO  
    @v_tbl,  
    @v_campo,  
    @v_tipo  
  END  
 
  SET @v_sql1 = 'insert into #Tab select top '+ CONVERT(VARCHAR(100),@top) +' ''insert into ' + @v_tbl_aux + ' ( ' + @v_sql1 + ') values ( '' + '  
    
  IF @condicao IS NULL   
   SET @v_sql2 = SUBSTRING ( @v_sql2, 1, LEN ( @v_sql2) - 3) + ')'' from ' + @v_tbl_aux + ';'  + CHAR(10)+CHAR(13)
  ELSE   
   SET @v_sql2 = SUBSTRING ( @v_sql2, 1, LEN ( @v_sql2) - 3) + ')'' from ' + @v_tbl_aux + ' where ' + @condicao + ';'  + CHAR(10)+CHAR(13)

  PRINT @v_sql1;  
  PRINT @v_sql2;  
  EXEC ( @v_sql1 + @v_sql2)  
 END  
 CLOSE Cur_Tabs_Campos  
 DEALLOCATE Cur_Tabs_Campos  
 
 IF @identity > 0 
 BEGIN;
                WITH cte AS ( 
                SELECT 'set identity_insert ' +  @v_tbl_aux + ' on ' AS x ,1 AS ordem
                UNION
                SELECT REPLACE ( QInsert, '''NULL''', 'NULL') AS x ,2 AS ordem FROM #Tab  
                UNION
                SELECT 'set identity_insert ' +  @v_tbl_aux + ' off ' AS x ,3 AS ordem
                )
                SELECT x FROM cte
                ORDER BY ordem
END
ELSE 
 BEGIN 
                SELECT REPLACE ( QInsert, '''NULL''', 'NULL') FROM #Tab  
 END

 DROP TABLE #Tab  
END

GO





--EXEC dbo.GeraScript @p_tbl_verifica = 'contrato', -- varchar(50)
--    @condicao = null, -- varchar(500)
--    @top = 99999999, -- int
--    @campoIgnorado = '', -- varchar(100)
--    @campoIgnorado2 = '', -- varchar(100)
--    @campoIgnorado3 = '', -- varchar(100)
--    @campoIgnorado4 = '', -- varchar(100)
--    @campoIgnorado5 = '', -- varchar(100)
--    @campoIgnorado6 = '' -- varchar(100)

