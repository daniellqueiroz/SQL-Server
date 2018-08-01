-- this script is a simple snippet for creating a unique constrait. It verifies the existence of a index and, if it does not exists, it creates it

IF NOT EXISTS (
SELECT OBJECT_NAME(si.object_id),si.*
FROM sys.indexes si, sys.index_columns  sic,sys.columns sc
WHERE 1=1
AND si.index_id = sic.index_id
AND sic.column_id = sc.column_id
AND si.object_id = sic.object_id
AND OBJECT_NAME(si.object_id) ='FormaPagamento'
and sc.name = 'nome'
AND OBJECT_NAME(sc.object_id) = OBJECT_NAME(si.object_id)
)
BEGIN
	CREATE UNIQUE INDEX IX_UQ_FormaPagamento_Nome ON dbo.FormaPagamento (Nome)
	PRINT 'indice criado'
END

-- generating drop comands for every unique constraint
SELECT ' alter table ' + OBJECT_NAME(parent_object_id) + ' DROP constraint ' + name FROM sys.key_constraints WHERE type='UQ' AND OBJECT_NAME(parent_object_id) IN (SELECT name FROM sys.tables)

