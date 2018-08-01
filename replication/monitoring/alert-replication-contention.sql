-- Use this script to automatically loop through the publications present on the server, verifyng the number of pending commands. If it is higher than the configured threshold, fire an email

USE distribution
go


DECLARE @corpo VARCHAR(500)
DECLARE @publicador VARCHAR(50), @publicacao varchar(50), @assinante varchar(50), @tipo tinyint, @servidor VARCHAR(50)
DECLARE @retornoOut INT, @assunto VARCHAR(4000)
DECLARE assinatura CURSOR  for
SELECT DISTINCT p.publisher_db,p.publication,s.subscriber_db,s.subscription_type,@@servername
FROM distribution.dbo.MSpublications p INNER JOIN distribution.dbo.MSsubscriptions s
ON p.publication_id = s.publication_id
WHERE subscriber_db !='virtual'
 OPEN assinatura
FETCH NEXT FROM assinatura INTO @publicador,@publicacao,@assinante,@tipo,@servidor

WHILE @@FETCH_STATUS <> -1
BEGIN
	EXEC distribution.dbo.sp_replmonitorsubscriptionpendingcmds_output @publisher = @servidor,
	@publisher_db = @publicador, 
	@publication = @publicacao,
	@subscriber = @servidor, 
	@subscriber_db = @assinante, 
	@subscription_type = @tipo,
	@retorno = @retornoOut OUTput
	
	--SELECT @retornoOut
	SET @assunto='Verificação Replicação - Comandos represados em ' + @assinante

	IF @retornoOut > 50000
	BEGIN
		EXEC sp_configure 'show advanced options',1
		RECONFIGURE
		EXEC sp_configure 'Database Mail Xps',1
		RECONFIGURE  

		SET @corpo = 'Verificar Replicação - Comandos represados em ' + @publicacao + ' - ' + @assinante;
		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'DBA', @recipients = 'ti.banco@novapontocom.com.br',@body = @corpo, @subject = @assunto

		EXEC sp_configure 'Database Mail Xps',0
		RECONFIGURE
		EXEC sp_configure 'show advanced options',0
		RECONFIGURE
	END
FETCH NEXT FROM assinatura INTO @publicador,@publicacao,@assinante,@tipo,@servidor
END
CLOSE assinatura
DEALLOCATE assinatura
GO


