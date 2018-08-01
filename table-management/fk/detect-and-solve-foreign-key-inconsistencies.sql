--createing auxiliary function #1
CREATE FUNCTION pegarcampoferenciado (@fk VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @campo VARCHAR(100)
	DECLARE @coluna INT
	DECLARE @tabela INT
	DECLARE @id INT
	SELECT @id = object_id FROM sys.foreign_keys WHERE name = @fk
	SELECT @tabela = referenced_object_id, @coluna = referenced_column_id FROM sys.foreign_key_columns WHERE constraint_object_id = @id
	SELECT @campo = name FROM sys.columns WHERE object_id = @tabela AND column_id = @coluna
RETURN @campo
END

GO

--createing auxiliary function #2
CREATE FUNCTION pegartabelareferenciada (@fk VARCHAR(100))
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @tabela VARCHAR(100)
	SELECT @tabela = OBJECT_NAME(referenced_object_id) FROM sys.foreign_keys WHERE name = @fk
	RETURN @tabela
END

GO

-- geting non-trusted foreign keys
SELECT * FROM sys.foreign_keys WHERE is_not_trusted = 1

-- making non-trusted foreign keys and check constraints trusted again
SELECT 'alter table ' + OBJECT_NAME(parent_object_id) + ' with check check constraint ' + name FROM sys.foreign_keys WHERE is_not_trusted = 1
SELECT 'alter table ' + OBJECT_NAME(parent_object_id) + ' with check check constraint ' + name,is_not_trusted,is_disabled,is_not_for_replication FROM sys.check_constraints WHERE is_not_trusted=1

--creating auxiliary table
IF OBJECT_ID('DBO.CHECKCONSTRAINTS') IS NULL --AND DB_ID('DBA') IS NOT NULL
BEGIN
	CREATE TABLE DBO.CHECKCONSTRAINTS (TABELA VARCHAR(500),FK VARCHAR(500), CONDICAO VARCHAR(1000))
END

TRUNCATE TABLE dbo.CHECKCONSTRAINTS

INSERT dbo.CHECKCONSTRAINTS
EXEC ('dbcc checkconstraints with all_constraints, no_infomsgs')

--SELECT * FROM dbo.CHECKCONSTRAINTS

SELECT DISTINCT tabela,dbo.pegartabelareferenciada(REPLACE(REPLACE(fk,'[',''),']','')), SUBSTRING(condicao,1,CHARINDEX('=',condicao,1)-1) FROM dbo.CHECKCONSTRAINTS

SELECT DISTINCT 'delete from ' + tabela + ' where ' + SUBSTRING(condicao,1,CHARINDEX('=',condicao,1)-1) + ' not in (select ' + dbo.pegarcampoferenciado(REPLACE(REPLACE(fk,'[',''),']','')) + ' from ' + dbo.pegartabelareferenciada(REPLACE(REPLACE(fk,'[',''),']','')) + ')' FROM dbo.CHECKCONSTRAINTS
