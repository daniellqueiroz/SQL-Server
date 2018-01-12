
/*

Remarks:

1. Besides CONTAINS, there are other constructs that you can use when working with full text search, such as FREETEXT, CONSTAINSTABLE and so on. FOr more information, check Microsoft documentation.

*/

IF OBJECT_ID('ListarCasamentosPorNoivos') IS NOT NULL
	DROP PROCEDURE dbo.ListarCasamentosPorNoivos;
GO

CREATE PROCEDURE ListarCasamentosPorNoivos
@PrimeiroNoivo VARCHAR(255),
@SegundoNoivo  VARCHAR(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @QtdDiaExcedido DATETIME;
	DECLARE @dataLimite DATETIME;
	DECLARE @pnoivo VARCHAR(1000),@snoivo VARCHAR(1000);
				
	SET @QtdDiaExcedido =(SELECT QtdDiaExcedido FROM dbo.Config);
	SET @dataLimite =(GETDATE() - (@QtdDiaExcedido));
	SET @pnoivo=@PrimeiroNoivo;
	SET @snoivo=@SegundoNoivo;

	IF @PrimeiroNoivo IS NOT NULL
	BEGIN
		SET @PrimeiroNoivo = @PrimeiroNoivo+'*';
		SET @PrimeiroNoivo = QUOTENAME(@PrimeiroNoivo,'"');
	END;
	IF @SegundoNoivo IS NOT NULL
	BEGIN
		SET @SegundoNoivo = @SegundoNoivo + '*';
		SET @SegundoNoivo = QUOTENAME(@SegundoNoivo,'"');
	END;
    
	IF @SegundoNoivo IS NOT NULL
	BEGIN
	;WITH cte AS 
	(
		(
			SELECT * FROM dbo.ListaCasamentoConsolidado
			WHERE 1=1
			AND CONTAINS ((NOMENOIVO,NOMENOIVA), @PrimeiroNoivo)
		)

		INTERSECT
		(
			SELECT * FROM dbo.ListaCasamentoConsolidado
			WHERE 1=1
			AND CONTAINS((NOMENOIVO,NOMENOIVA), @SegundoNoivo)
		)
	)

	SELECT * 
	FROM cte
	WHERE 1=1
	AND DATAEVENTO > @dataLimite
	AND 
		(
			(nomenoivo  LIKE '%'+@pnoivo+'%' OR nomenoivo   LIKE '%'+@snoivo+'%') 
			AND 
			(nomenoiva  LIKE '%'+@pnoivo+'%' OR nomenoiva  LIKE '%'+@snoivo+'%') 
		)
	ORDER BY DATAEVENTO;

	END;

	ELSE

	BEGIN
		;WITH cte AS (
		SELECT * FROM dbo.ListaCasamentoConsolidado
		WHERE 1=1
		AND CONTAINS ((NOMENOIVA,NOMENOIVO), @PrimeiroNoivo)
		
		)
		SELECT * FROM cte
		WHERE 1=1
		AND cte.DATAEVENTO > @dataLimite
		ORDER BY cte.DATAEVENTO;
	END;  
END;