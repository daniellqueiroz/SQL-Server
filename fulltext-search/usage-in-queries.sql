/*

Remarks:

1. Besides CONTAINS, there are other constructs that you can use when working with full text search, such as FREETEXT, CONSTAINSTABLE and so on. FOr more information, check Microsoft documentation.

*/

DECLARE @noiva VARCHAR(1000)='FCHCMBSD5U0NSJXS'
DECLARE @noivo VARCHAR(1000)='maria',@nomenoivos VARCHAR(1000)

IF @noiva IS NOT NULL
BEGIN
	SET @noiva=@noiva+'*'
	SET @noiva=QUOTENAME(@noiva,'"')
END

IF @noivo IS NOT NULL
BEGIN
	SET @noivo=@noivo+'*'
	SET @noivo=QUOTENAME(@noivo,'"')
END

SET @nomenoivos = COALESCE(@noiva,'"*"') + ' or ' + COALESCE(@noivo,'"*"')

SELECT NOMENOIVA,NOMENOIVO FROM dbo.ListaCasamentoConsolidado WHERE 
1=1
AND CONTAINS((NOMENOIVA,NOMENOIVO),@nomenoivos) 
AND @nomenoivos IS NOT NULL

