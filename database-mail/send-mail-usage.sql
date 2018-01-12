/*

Remarks:

1. This is a sample procedure that uses database mail to fire reports to decision makers. The procedure extracts contents from the database and show them in HTML format.

*/


CREATE PROCEDURE [dbo].[RelatorioKitSemGarantiaOuValorInvalido]
AS
DECLARE @Destinatarios VARCHAR(500);
DECLARE @Assunto       VARCHAR(500);
DECLARE @Profile       VARCHAR(100);
DECLARE @idSkuServicoTipo INT;  

SET @Profile = 'DBA'; -- specify the DatabaseMail profile created previously
SET @Destinatarios = 'gono@gono.com'; -- who is going to receive the email
SET @Assunto = 'Alerta de Kits sem GarantiaKit ou com Valor Inválido - EXTRA'; -- email subject
SET @idSkuServicoTipo = 127;  

SET CONCAT_NULL_YIELDS_NULL OFF; -- this may be necessary in order to avoid problems with NULL values

/**** BEGINING OF REPORT QUERY ****/
  SELECT skf.idSkuPai  
         ,COUNT(skf.idSku) quantSkuElegiveis  
         ,ss.Prazo  
    INTO #tmpKitPrazo  
    FROM dbo.SkuKitFilho skf (NOLOCK)  
    INNER JOIN dbo.SkuServico ss (NOLOCK)  
      ON ss.IdSku = skf.idSku  
         AND ss.FlagAtiva = 1  
         AND ss.Prazo IS NOT NULL  
         AND ss.IdSkuServicoTipo = @idSkuServicoTipo  
         AND ss.Prefixo IS NOT NULL
    INNER JOIN dbo.Sku s (NOLOCK)
      ON s.IdSKU = skf.idSkuPai  
   WHERE s.flagKit = 1  
         AND s.IdSKU > 1000000000  
         AND ISNULL(skf.FlagExcluiGES, 0) = 0  
   GROUP BY skf.idSkuPai  
            ,ss.Prazo  
    
  HAVING COUNT(skf.idSku) = (  
  
            SELECT COUNT(DISTINCT skf2.idSku)  
               FROM SkuKitFilho skf2 (NOLOCK)  
               INNER JOIN SkuServico ss2 (NOLOCK)  
                 ON ss2.IdSku = skf2.idSku  
              WHERE ss2.FlagAtiva = 1  
                    AND ss2.Prazo IS NOT NULL  
                    AND ss2.IdSkuServicoTipo = @idSkuServicoTipo  
                    AND skf2.idSkuPai = skf.idSkuPai  
                    AND ISNULL(skf2.FlagExcluiGES, 0) = 0  
              GROUP BY skf2.idSkuPai);  
  

SELECT t.idSkuPai, Prazo, Valor, ValorComposicao, t.Descricao
  INTO #tmpGarantiaKit  
FROM
(
	SELECT DISTINCT #tmpKitPrazo.idSkuPai, #tmpKitPrazo.Prazo 'Prazo', '' 'Valor', '' 'ValorComposicao', 'Kit não possui Valor da Composição(GarantiaKit).' 'Descricao'
	FROM #tmpKitPrazo WITH (NOLOCK)
	INNER JOIN Sku WITH (NOLOCK)
	ON Sku.IdSKU = #tmpKitPrazo.idSkuPai
	AND Sku.FlagAtiva = 1
	LEFT JOIN GarantiaKit WITH (NOLOCK)
	ON GarantiaKit.idSkuKit = #tmpKitPrazo.idSkuPai
	AND GarantiaKit.Prazo = #tmpKitPrazo.Prazo
	WHERE GarantiaKit.idSkuKit IS NULL
	
	UNION
	
	SELECT #tmpKitPrazo.idSkuPai
		, CAST(#tmpKitPrazo.Prazo AS VARCHAR)
		, CAST(SkuServicoValor.Valor AS VARCHAR)
		, CAST((SELECT SUM(Valor) 
					FROM GarantiaKit WITH (NOLOCK)
				WHERE GarantiaKit.idSkuKit = #tmpKitPrazo.idSkuPai 
					AND GarantiaKit.Prazo = #tmpKitPrazo.Prazo)AS VARCHAR) 'ValorComposicao'
		, 'Valor Exibido é diferente do Valor da Composição.' 'Descricao'
	FROM #tmpKitPrazo WITH (NOLOCK)
	INNER JOIN SkuServico WITH (NOLOCK)
		ON SkuServico.IdSku = #tmpKitPrazo.idSkuPai
		AND SkuServico.Prazo = #tmpKitPrazo.Prazo
		AND SkuServico.IdSkuServicoTipo = @idSkuServicoTipo  
		AND SkuServico.FlagAtiva = 1
		AND SkuServico.PlanoIndisponivel = 0
	INNER JOIN SkuServicoValor WITH (NOLOCK)
		ON SkuServicoValor.IdSkuServicoValor = SkuServico.IdSkuServicoValor
	WHERE SkuServicoValor.Valor <> (SELECT SUM(Valor) 
										FROM GarantiaKit WITH (NOLOCK)
									WHERE GarantiaKit.idSkuKit = #tmpKitPrazo.idSkuPai 
										AND GarantiaKit.Prazo = #tmpKitPrazo.Prazo)
) t;

/***** END OF REPORT QUERY *****/

/**** BEGINING OF REPORT FORMAT (HTML STYLE). NOTE THAT I USE XQUERY TO ALLOW IN-LINE FORMATING ****/
IF (SELECT COUNT(1) FROM #tmpGarantiaKit) > 0
BEGIN

DECLARE @MsgBody NVARCHAR(MAX);

SET @MsgBody = N'<html><head><title>Data files report</title></head><body><table border= "1"><tr><td>IdSkuKit</td><td>Prazo Serviço</td><td>Valor Exibido</td><td>Valor Composição</td><td>Descrição</td></tr>' 
+
CAST ((
		SELECT 
		td = tab1.idSkuPai,''
		,td = tab1.Prazo,''
		,td = tab1.Valor,''
		,td = tab1.ValorComposicao,''
		,td = tab1.Descricao
		FROM (
				 SELECT idSkuPai, Prazo, Valor, ValorComposicao, Descricao FROM #tmpGarantiaKit
			  ) tab1
		ORDER BY tab1.idSkuPai,tab1.Prazo
		FOR XML PATH('tr'),TYPE
		
	) AS NVARCHAR(MAX) )  +
    N'</table></body></html>' ;
/**** END OF REPORT FORMAT (HTML STYLE) ****/

 EXEC sp_configure 'show advanced option',1;  -- ENABLING ADVANCED OPTIONS WITHIN SQL SERVER CONFIGURATIONS
 RECONFIGURE WITH OVERRIDE;  
  
  
 EXEC sp_configure 'Database Mail XPs', 1;  -- ENABLING DATABASE MAIL EXTENDED PROCEDURES. CAUTION: IT IS ADVISABLE TO DISABLE AFTER USING IT!
 RECONFIGURE WITH OVERRIDE;  

EXEC msdb.dbo.sp_send_dbmail     
     @profile_name = @Profile
     ,@body = @MsgBody
     ,@body_format = 'HTML'     
     ,@recipients = @Destinatarios
     ,@subject = @Assunto     
     ,@query_result_no_padding = 1
     ,@query_result_header = 0;

     
DROP TABLE #tmpKitPrazo;
DROP TABLE #tmpGarantiaKit;

END;