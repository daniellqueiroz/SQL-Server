-- run this to get a list of all check and default_constraints on the database (with ther definition)

SELECT 'Check' AS TipoConstraint, df.name,OBJECT_NAME(df.parent_object_id) AS 'Tabela', CASE WHEN (SELECT name + ';' FROM sys.columns WHERE column_id=df.parent_column_id AND object_id=df.parent_object_id FOR XML PATH('')) IS NULL THEN 'Não se aplica' ELSE (SELECT name + ';' FROM sys.columns WHERE column_id=df.parent_column_id AND object_id=df.parent_object_id FOR XML PATH('')) END AS 'Campos Chave', df.definition FROM sys.check_constraints df

UNION

SELECT 'Default' AS TipoConstraint,df.name,OBJECT_NAME(df.parent_object_id) AS 'Tabela',(SELECT name + ';' FROM sys.columns WHERE column_id=df.parent_column_id AND object_id=df.parent_object_id FOR XML PATH('')) AS 'Campos Chave',df.definition FROM sys.default_constraints df WHERE is_ms_shipped=0



--EXEC (@cmd)
--SELECT @cmd