if object_id('HistoricoVersaoObjeto','U') is not null
BEGIN

IF NOT EXISTS (SELECT * FROM SYS.columns WHERE NAME = 'checks' AND object_id=object_id('HistoricoVersaoObjeto')) and object_id('HistoricoVersaoObjeto','U') is not null
ALTER TABLE dbo.HistoricoVersaoObjeto ADD checks AS CHECKSUM(CAST(texto AS NVARCHAR(max))) PERSISTED

DELETE FROM dbo.HistoricoVersaoObjeto WHERE DatabaseLogID IN (
SELECT DatabaseLogID FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY Object ORDER BY DataAlteracao desc) AS rownum
FROM dbo.HistoricoVersaoObjeto
WHERE event LIKE 'DROP%'
) AS a
WHERE a.rownum>1
)

DELETE FROM dbo.HistoricoVersaoObjeto WHERE DatabaseLogID IN (
SELECT DatabaseLogID FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY Object,checks,Event ORDER BY DataAlteracao desc) AS rownum
FROM dbo.HistoricoVersaoObjeto
--WHERE event LIKE 'create%'
) AS a
WHERE a.rownum>1
--AND a.Object='ArquivoCampoXmlListar'
)

DELETE FROM dbo.HistoricoVersaoObjeto WHERE Event IN ('GRANT_DATABASE')
DELETE FROM dbo.HistoricoVersaoObjeto WHERE Object LIKE 'dbo.%'

END

--SELECT * FROM (
--SELECT *, ROW_NUMBER() OVER (PARTITION BY checks ORDER BY DataAlteracao desc) AS rownum
--FROM dbo.HistoricoVersaoObjeto
----WHERE event LIKE 'create%'
--) AS a
--WHERE a.rownum>1


SELECT * FROM dbo.HistoricoVersaoObjeto WHERE Object='trListaDeCompraEventoUpdate'

