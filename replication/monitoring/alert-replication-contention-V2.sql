--SELECT @@servername
--EXEC sp_serveroption [CL-HL-HSQLWEB01\HSQLWEB01], 'data access', true;

USE distribution
go


IF OBJECT_ID('Erros','U') IS NOT NULL
DROP TABLE dbo.Erros
GO

CREATE TABLE [dbo].[Erros]
(
[id] [int] NOT NULL,
[time] [datetime] NOT NULL,
[error_type_id] [int] NULL,
[source_type_id] [int] NULL,
[source_name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[error_code] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[error_text] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[xact_seqno] [varbinary] (16) NULL,
[command_id] [int] NULL,
[session_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

SET NOCOUNT ON 

DECLARE @corpo VARCHAR(500),@cmd VARCHAR(8000)
DECLARE @publicador VARCHAR(50), @publicacao varchar(50), @assinante varchar(50), @tipo tinyint, @servidor VARCHAR(50)
DECLARE @retornoOut INT, @assunto VARCHAR(4000)
DECLARE assinatura CURSOR  for

SELECT DISTINCT
'exec sp_helpsubscriptionerrors  @publisher =  ''' + @@servername + ''',  @publisher_db =  ''' + p.publisher_db + ''' 
,  @publication =  ''' + p.publication +'''
,  @subscriber =  ''' + @@SERVERNAME +'''
,  @subscriber_db =  ''' + s.subscriber_db + ''''
 ,p.publisher_db,p.publication,s.subscriber_db,s.subscription_type,@@servername
FROM distribution.dbo.MSpublications p INNER JOIN distribution.dbo.MSsubscriptions s
ON p.publication_id = s.publication_id
WHERE subscriber_db !='virtual'

 OPEN assinatura
FETCH NEXT FROM assinatura INTO @cmd,@publicador,@publicacao,@assinante,@tipo,@servidor

WHILE @@FETCH_STATUS <> -1
BEGIN

	TRUNCATE TABLE dbo.Erros;

	EXEC distribution.dbo.sp_replmonitorsubscriptionpendingcmds_output @publisher = @servidor,
	@publisher_db = @publicador, 
	@publication = @publicacao,
	@subscriber = @servidor, 
	@subscriber_db = @assinante, 
	@subscription_type = @tipo,
	@retorno = @retornoOut OUTput
	
	EXEC ('insert dbo.erros ' + @cmd);

	--SELECT * FROM dbo.Erros

	SET @assunto='Verificação Replicação - Erros em ' + @publicacao

	IF EXISTS(SELECT TOP 1 time FROM dbo.Erros WHERE time> DATEADD(hh,-6,GETDATE())) AND @retornoOut > 10
	BEGIN
		EXEC sp_configure 'show advanced options',1
		RECONFIGURE
		EXEC sp_configure 'Database Mail Xps',1
		RECONFIGURE  

		SET @corpo = 'Verificar Replicação - Erros em ' + @publicacao + ' - ' + @assinante;
		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'DBA', @recipients = 'rafael.bahia@novapontocom.com.br',@body = @corpo, @subject = @assunto

		EXEC sp_configure 'Database Mail Xps',0
		RECONFIGURE
		EXEC sp_configure 'show advanced options',0
		RECONFIGURE
	END
FETCH NEXT FROM assinatura INTO @cmd,@publicador,@publicacao,@assinante,@tipo,@servidor
END
CLOSE assinatura
DEALLOCATE assinatura
GO


