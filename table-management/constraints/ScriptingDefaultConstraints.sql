-- run this to make a backup of all default constraints within the database

SELECT DISTINCT 'if not exists (select dc.* from sys.default_constraints dc, sys.columns sc where 1=1 and dc.parent_object_id = sc.object_id and dc.parent_column_id = sc.column_id and dc.definition = ''' +REPLACE([definition],'''','''''')+ ''' and sc.name = ''' + sc.name + ''' and dc.parent_object_id=object_id(''' + OBJECT_NAME(dc.parent_object_id) + ''')) and object_id(''' + OBJECT_NAME(dc.parent_object_id) + ''') is not null  alter table ' + OBJECT_NAME(dc.parent_object_id) + ' add constraint DF_' +  OBJECT_NAME(dc.parent_object_id) + '_' + sc.name + ' DEFAULT ' + dc.definition + ' FOR ' + sc.name,OBJECT_NAME(dc.parent_object_id)
FROM sys.default_constraints dc, sys.columns sc
WHERE 1=1
AND dc.parent_object_id = sc.object_id
AND dc.parent_column_id = sc.column_id
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'MS%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'sys%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'AUDIT%'
ORDER BY OBJECT_NAME(dc.parent_object_id)


-- run this to get the default constraints' definition
SELECT OBJECT_NAME(dc.parent_object_id) AS NomeDaTabela, sc.name AS NomeDoCampoComDefaultConstraint, dc.[definition] AS 'Valor Default'
FROM sys.default_constraints dc, sys.columns sc
WHERE 1=1
AND dc.parent_object_id = sc.object_id
AND dc.parent_column_id = sc.column_id
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'MS%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'sys%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'AUDIT%'
ORDER BY OBJECT_NAME(dc.parent_object_id)


-- Lista todas as DFC concatenadamente
SELECT OBJECT_NAME(dc.parent_object_id) + '.' + sc.name + ' = ' + dc.[definition] AS 'Concatenado'
FROM sys.default_constraints dc, sys.columns sc
WHERE 1=1
AND dc.parent_object_id = sc.object_id
AND dc.parent_column_id = sc.column_id
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'MS%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'sys%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'AUDIT%'
ORDER BY OBJECT_NAME(dc.parent_object_id)

--run this to recreate all default constraints so that they can conform with your name pattern. THis can be useful to rename constraints that received SQL Server's automatically generated name
SELECT 'if exists (select * from sys.default_constraints where name = ''' + dc.name + ''') alter table ' + OBJECT_NAME(dc.parent_object_id) + ' drop constraint ' + dc.name + CHAR(13) + '; alter table ' + OBJECT_NAME(dc.parent_object_id) + ' add constraint DF_' +  OBJECT_NAME(dc.parent_object_id) + '_' + sc.name + ' DEFAULT ' + dc.definition + ' FOR ' + sc.name
FROM sys.default_constraints dc, sys.columns sc
WHERE 1=1
AND dc.parent_object_id = sc.object_id
AND dc.parent_column_id = sc.column_id
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'MS%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'sys%'
AND OBJECT_NAME(dc.parent_object_id) NOT LIKE 'AUDIT%'
AND (
		dc.name LIKE '%1%'
		OR dc.name LIKE '%0%'
		OR dc.name LIKE '%2%'
		OR dc.name LIKE '%3%'
		OR dc.name LIKE '%4%'
		OR dc.name LIKE '%5%'
		OR dc.name LIKE '%6%'
		OR dc.name LIKE '%7%'
		OR dc.name LIKE '%8%'
		OR dc.name LIKE '%9%'
		
	)
ORDER BY OBJECT_NAME(dc.parent_object_id)



