DECLARE @Destinatarios VARCHAR(500);
DECLARE @Assunto       VARCHAR(500);
DECLARE @Profile       VARCHAR(100);
DECLARE @MsgBody NVARCHAR(MAX)

SET @Profile = 'DBA';
SET @Destinatarios = 'rafael.bahia@cnova.com'
SET @Assunto = 'Replicação CORP - LOJA com erros em Homologação';

IF EXISTS(
SELECT TOP 1 * FROM [CL-HLG-HSQLECOM.DC.NOVA\HSQLECOM].distribution.dbo.MSrepl_errors WHERE [time] > DATEADD(MINUTE,-15,GETDATE()) 
)
BEGIN
	SET @MsgBody = N'<html><head><title>Data files report</title></head><body><table border= "1"><tr><td>DataHora</td><td>error code</td><td>error text</td></tr>' 
	+
	CAST ((
			SELECT 
			td = tab1.[time],''
			,td = tab1.error_code,''
			,td = tab1.error_text
			FROM (
					 SELECT TOP 10 [time],error_code, error_text FROM [CL-HLG-HSQLECOM.DC.NOVA\HSQLECOM].distribution.dbo.MSrepl_errors WHERE [time] > DATEADD(MINUTE,-15,GETDATE()) 
				  ) tab1
			FOR XML PATH('tr'),TYPE
		
		) AS NVARCHAR(MAX) )  +
		N'</table></body></html>' ;

	--PRINT @MsgBody
	EXEC msdb.dbo.sp_send_dbmail @profile_name = @Profile,@body = @MsgBody,@body_format = 'HTML',@recipients = @Destinatarios,@subject = @Assunto,@query_result_no_padding = 1,@query_result_header = 0

end




