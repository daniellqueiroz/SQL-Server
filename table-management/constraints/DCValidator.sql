--run this script to generate update commands for the columns that have default values so that they conform with these constraints

SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF

DECLARE @updates TABLE (updates VARCHAR(1000))
DECLARE @tabela VARCHAR(500),@campo VARCHAR(500), @valor VARCHAR(500)
DECLARE @IntVariable INT;
DECLARE @SQLString NVARCHAR(500);
DECLARE @ParmDefinition NVARCHAR(500);
DECLARE @count INT

DECLARE dfviolada CURSOR FOR
SELECT OBJECT_NAME(dc.parent_object_id) AS NomeDaTabela, sc.name AS NomeDoCampoComDefaultConstraint, REPLACE(REPLACE(dc.[definition],'(',''),')','') AS 'Valor Default'
FROM sys.default_constraints dc, sys.columns sc
WHERE 1=1
AND dc.parent_object_id = sc.object_id
AND dc.parent_column_id = sc.column_id
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'MS%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'sys%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'AUDIT%'
--and object_name(dc.parent_object_id) in ('clienteendereco')
--and left(object_name(dc.parent_object_id),1) < 'L'
ORDER BY OBJECT_NAME(dc.parent_object_id)

OPEN dfviolada
FETCH NEXT FROM dfviolada INTO @tabela, @campo, @valor
WHILE @@FETCH_STATUS <> -1
BEGIN


	SET @SQLString = N'SELECT @countout = COUNT(*) FROM '+@tabela+' with (nolock) WHERE '+@campo +' IS NULL'
	SET @ParmDefinition = N'@countout int output'
	
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @countOUT=@count OUTPUT;
	
	IF @count > 0 
	BEGIN;
		WITH cte AS (
		--SELECT @tabela + ' ----- ' + @campo + ' ----- ' + @valor + ' == quantidade == ' + CAST(@count AS VARCHAR(100)) AS ROUTINE_NAME,1 AS ordem
		--UNION
		SELECT SPACE(3) + 'update ' + @tabela + ' set ' + @campo + ' = ' + @valor + ' where ' + @campo + ' is null' AS routine_name,2 AS ordem
		--UNION
		--SELECT SPACE(3) + 'exec sp_helptext '''+ROUTINE_SCHEMA+'.'+ROUTINE_NAME+'''',3 AS ordem FROM INFORMATION_SCHEMA.ROUTINES 
		--WHERE 1=1
		--AND SQL_DATA_ACCESS = 'modifies'
		----AND routine_name IN (SELECT REPLACE(nome,'dbo.','') FROM temp)
		----AND routine_name = 'spCompraEntregaSkuAlterar'
		--AND (
		--	ROUTINE_DEFINITION LIKE '%update%'+@tabela+'%'
		--	OR
		--	ROUTINE_DEFINITION LIKE '%insert%'+@tabela+'%'
		--	)
		--AND ROUTINE_DEFINITION LIKE '%'+@campo+'%'
		--AND ROUTINE_NAME NOT LIKE '%lista%'
		--AND ROUTINE_NAME NOT LIKE '%APAGA%'
		--AND ROUTINE_NAME NOT LIKE '%exclui%'
		)
		SELECT ROUTINE_NAME FROM cte
		WHERE @count != 0 AND @valor !='NULL'
		ORDER BY ordem		
	END	
	
	IF @count > 0 AND @valor !='NULL'
	BEGIN
		SET @SQLString = 'update ' + @tabela + ' set ' + @campo + ' = ' + CASE @valor WHEN 'getdate' THEN 'getdate()' ELSE @valor END + ' where ' + @campo + ' is null --- ' + CAST(@count AS VARCHAR(100))
		INSERT @updates VALUES (@SQLString)
	END

FETCH NEXT FROM dfviolada INTO @tabela, @campo, @valor
END
CLOSE dfviolada
DEALLOCATE dfviolada

SELECT * FROM @updates

